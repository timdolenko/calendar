import Foundation
import Combine
import CalendarDomain
import CalendarCore

@MainActor
public class CalendarViewModel: ObservableObject {
    @Published private(set) var months: [Date] = []
    @Published private(set) var eventsByMonth: [Date: [Event]] = [:]
    @Published private(set) var loadingState = LoadingState.idle
    @Published private(set) var error: Error?
    
    private let calendar = Calendar.current
    private let monthsToLoad = 12
    private let eventRepository: EventRepository
    private let cache: EventCache
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private let pageSize = 3
    
    public init(eventRepository: EventRepository, cache: EventCache = EventCache.shared) {
        self.eventRepository = eventRepository
        self.cache = cache
        setupInitialMonths()
        loadInitialEvents()
    }
    
    private func setupInitialMonths() {
        let today = Date()
        let startDate = calendar.date(byAdding: .month, value: -6, to: today)!
        
        months = (0..<monthsToLoad).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: startDate)
        }
    }
    
    func loadMoreIfNeeded(currentMonth: Date) {
        guard let lastMonth = months.last,
              currentMonth == lastMonth,
              loadingState == .idle else { return }
        
        currentPage += 1
        let newMonths = (1...pageSize).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: lastMonth)
        }
        months.append(contentsOf: newMonths)
        loadEvents(for: newMonths)
    }
    
    private func loadInitialEvents() {
        Task {
            // Try loading from cache first
            if let cachedEvents = await cache.getEvents() {
                let eventsByMonth = Dictionary(grouping: cachedEvents) { event in
                    calendar.startOfMonth(for: event.startDate)
                }
                self.eventsByMonth = eventsByMonth
            }
            await loadEvents(for: months)
        }
    }
    
    private func loadEvents(for months: [Date]) {
        guard let firstMonth = months.first,
              let lastMonth = months.last,
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: firstMonth)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: lastMonth)
        else { return }
        
        Task {
            do {
                loadingState = .loading
                error = nil
                
                let events = try await eventRepository.getEvents(from: monthStart, to: monthEnd)
                let eventsByMonth = Dictionary(grouping: events) { event in
                    calendar.startOfMonth(for: event.startDate)
                }
                
                // Cache the events
                await cache.save(events: events)
                
                await MainActor.run {
                    self.eventsByMonth.merge(eventsByMonth) { _, new in new }
                    self.loadingState = .idle
                }
            } catch {
                self.error = error
                self.loadingState = .error(error)
            }
        }
    }
    
    func events(for month: Date) -> [Event] {
        let monthStart = calendar.startOfMonth(for: month)
        return eventsByMonth[monthStart] ?? []
    }
}

public enum LoadingState: Equatable {
    case idle
    case loading
    case error(Error)
    
    public static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        dateInterval(of: .month, for: date)?.start ?? date
    }
}
