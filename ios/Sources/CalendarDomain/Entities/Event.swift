import Foundation

public struct Event: Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let startDate: Date
    public let endDate: Date
    public let description: String?
    public let location: String?
    public let color: String
    public let userId: UUID
    public var recurrence: EventRecurrence?
    
    public init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        endDate: Date,
        description: String? = nil,
        location: String? = nil,
        color: String,
        userId: UUID,
        recurrence: EventRecurrence? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.location = location
        self.color = color
        self.userId = userId
        self.recurrence = recurrence
    }
}