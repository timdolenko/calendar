import Foundation

public struct EventRecurrence: Hashable {
    public enum Frequency: String {
        case daily
        case weekly
        case monthly
        case yearly
    }
    
    public let id: UUID
    public let eventId: UUID
    public let frequency: Frequency
    public let interval: Int
    public let until: Date?
    public let byDay: Set<Weekday>
    
    public init(
        id: UUID = UUID(),
        eventId: UUID,
        frequency: Frequency,
        interval: Int = 1,
        until: Date? = nil,
        byDay: Set<Weekday> = []
    ) {
        self.id = id
        self.eventId = eventId
        self.frequency = frequency
        self.interval = interval
        self.until = until
        self.byDay = byDay
    }
}

public enum Weekday: String, CaseIterable {
    case sunday = "SU"
    case monday = "MO"
    case tuesday = "TU"
    case wednesday = "WE"
    case thursday = "TH"
    case friday = "FR"
    case saturday = "SA"
}