import SwiftUI

struct DayCell: View {
    let date: Date
    let events: [Event]
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date.formatted(.dateTime.day()))
                .font(.subheadline)
            
            if !events.isEmpty {
                ForEach(events.prefix(3)) { event in
                    EventIndicator(event: event)
                }
                
                if events.count > 3 {
                    Text("+\(events.count - 3)")
                        .font(.caption2)
                }
            }
        }
        .frame(height: 80)
        .padding(4)
    }
}