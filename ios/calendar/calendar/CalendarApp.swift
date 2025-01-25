import SwiftUI
import CalendarUI
import CalendarDomain
import CalendarNetwork
import CalendarCore

@main
struct CalendarApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                InfiniteCalendarView(
                    viewModel: .init(
                        eventRepository: EventRepositoryImpl()
                    )
                )
            } else {
                AuthView(viewModel: .init())
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    // Add more app-wide state here
}
