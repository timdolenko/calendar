import Foundation

public protocol EventRepository {
    func getEvents(from: Date, to: Date) async throws -> [Event]
    func createEvent(_ event: Event) async throws -> Event
    func updateEvent(_ event: Event) async throws -> Event
    func deleteEvent(_ eventId: UUID) async throws
}