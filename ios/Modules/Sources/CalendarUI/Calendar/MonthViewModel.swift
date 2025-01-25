import Foundation

@MainActor
public class MonthViewModel: ObservableObject {
    @Published private(set) var days: [Date] = []
    private let calendar = Calendar.current
    private let month: Date
    private let events: [Event]
    
    public init(month: Date, events: [Event] = []) {
        self.month = month
        self.events = events
        calculateDays()
    }
    
    private func calculateDays() {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return }
        
        let startDate = monthFirstWeek.start
        let endDate = monthLastWeek.end
        
        days = calendar.generateDates(
            inside: DateInterval(start: startDate, end: endDate),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    func eventsForDay(_ date: Date) -> [Event] {
        events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date)
        }
    }
    
    var monthTitle: String {
        month.formatted(.dateTime.month(.wide))
    }
}

private extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.reserveCapacity(42)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            guard date < interval.end else {
                stop = true
                return
            }
            dates.append(date)
        }
        
        return dates
    }
}