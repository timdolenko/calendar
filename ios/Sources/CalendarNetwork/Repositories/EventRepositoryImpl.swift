import Foundation
import CalendarDomain
import Supabase

public final class EventRepositoryImpl: EventRepository {
    private let client: SupabaseClient
    
    public init(client: SupabaseClient = .shared) {
        self.client = client
    }
    
    public func getEvents(from: Date, to: Date) async throws -> [Event] {
        let events: [EventDTO] = try await client.getClient()
            .database
            .from("events")
            .select("""
                id, title, start_date, end_date, description, 
                location, color, user_id, 
                recurrence (id, event_id, frequency, interval, until, by_day)
            """)
            .gte("start_date", value: from)
            .lte("end_date", value: to)
            .execute()
            .value
        
        return events.map { dto in
            // Transform DTO to Domain model
            Event(
                id: dto.id,
                title: dto.title,
                startDate: dto.startDate,
                endDate: dto.endDate,
                description: dto.description,
                location: dto.location,
                color: dto.color,
                userId: dto.userId
                // Add recurrence mapping
            )
        }
    }
    
    public func createEvent(_ event: Event) async throws -> Event {
        let dto = try await client.getClient()
            .database
            .from("events")
            .insert(EventDTO(
                id: event.id,
                title: event.title,
                startDate: event.startDate,
                endDate: event.endDate,
                description: event.description,
                location: event.location,
                color: event.color,
                userId: event.userId,
                recurrence: event.recurrence.map { rec in
                    RecurrenceDTO(
                        id: rec.id,
                        eventId: event.id,
                        frequency: rec.frequency.rawValue,
                        interval: rec.interval,
                        until: rec.until,
                        byDay: Array(rec.byDay).map(\.rawValue).joined(separator: ",")
                    )
                }
            ))
            .select()
            .single()
            .execute()
            .value

        return Event(
            id: dto.id,
            title: dto.title,
            startDate: dto.startDate,
            endDate: dto.endDate,
            description: dto.description,
            location: dto.location,
            color: dto.color,
            userId: dto.userId,
            recurrence: dto.recurrence.map { rec in
                EventRecurrence(
                    id: rec.id,
                    eventId: rec.eventId,
                    frequency: .init(rawValue: rec.frequency) ?? .daily,
                    interval: rec.interval,
                    until: rec.until,
                    byDay: Set(rec.byDay?.split(separator: ",").compactMap { Weekday(rawValue: String($0)) } ?? [])
                )
            }
        )
    }

    public func updateEvent(_ event: Event) async throws -> Event {
        let dto = try await client.getClient()
            .database
            .from("events")
            .update(EventDTO(
                id: event.id,
                title: event.title,
                startDate: event.startDate,
                endDate: event.endDate,
                description: event.description,
                location: event.location,
                color: event.color,
                userId: event.userId,
                recurrence: event.recurrence.map { rec in
                    RecurrenceDTO(
                        id: rec.id,
                        eventId: event.id,
                        frequency: rec.frequency.rawValue,
                        interval: rec.interval,
                        until: rec.until,
                        byDay: Array(rec.byDay).map(\.rawValue).joined(separator: ",")
                    )
                }
            ))
            .eq("id", value: event.id)
            .select()
            .single()
            .execute()
            .value

        return Event(
            id: dto.id,
            title: dto.title,
            startDate: dto.startDate,
            endDate: dto.endDate,
            description: dto.description,
            location: dto.location,
            color: dto.color,
            userId: dto.userId,
            recurrence: dto.recurrence.map { rec in
                EventRecurrence(
                    id: rec.id,
                    eventId: rec.eventId,
                    frequency: .init(rawValue: rec.frequency) ?? .daily,
                    interval: rec.interval,
                    until: rec.until,
                    byDay: Set(rec.byDay?.split(separator: ",").compactMap { Weekday(rawValue: String($0)) } ?? [])
                )
            }
        )
    }

    public func deleteEvent(_ eventId: UUID) async throws {
        try await client.getClient()
            .database
            .from("events")
            .delete()
            .eq("id", value: eventId)
            .execute()
    }
}