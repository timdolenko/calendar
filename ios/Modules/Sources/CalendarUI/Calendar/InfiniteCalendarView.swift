import SwiftUI

public struct InfiniteCalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    
    public init(viewModel: CalendarViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.months, id: \.self) { month in
                    MonthView(month: month, events: viewModel.events(for: month))
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentMonth: month)
                        }
                }
            }
        }
    }
}