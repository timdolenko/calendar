import SwiftUI

public struct MonthView: View {
    @StateObject private var viewModel: MonthViewModel
    
    public init(month: Date, events: [Event] = []) {
        _viewModel = StateObject(wrappedValue: MonthViewModel(month: month, events: events))
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            monthHeader
            daysGrid
        }
    }
    
    private var monthHeader: some View {
        Text(viewModel.monthTitle)
            .font(.title2)
            .padding(.vertical, 8)
    }
    
    private var daysGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
            ForEach(viewModel.days, id: \.self) { date in
                DayCell(date: date, events: viewModel.eventsForDay(date))
            }
        }
    }
}