import Foundation

struct EventDTO: Codable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    let description: String?
    let location: String?
    let color: String
    let userId: UUID
    let recurrence: RecurrenceDTO?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case description
        case location
        case color
        case userId = "user_id"
        case recurrence
    }
}

struct RecurrenceDTO: Codable {
    let id: UUID
    let eventId: UUID
    let frequency: String
    let interval: Int
    let until: Date?
    let byDay: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case frequency
        case interval
        case until
        case byDay = "by_day"
    }
}