import Foundation
import CalendarDomain

public actor EventCache {
    public static let shared = EventCache()
    
    private let cache = NSCache<NSString, CachedEvents>()
    private let expirationInterval: TimeInterval = 60 * 5 // 5 minutes
    
    private init() {}
    
    public func save(events: [Event]) {
        let cached = CachedEvents(events: events, timestamp: Date())
        cache.setObject(cached, forKey: "events" as NSString)
    }
    
    public func getEvents() -> [Event]? {
        guard let cached = cache.object(forKey: "events" as NSString),
              Date().timeIntervalSince(cached.timestamp) < expirationInterval
        else { return nil }
        
        return cached.events
    }
    
    public func clear() {
        cache.removeAllObjects()
    }
}

private final class CachedEvents: NSObject {
    let events: [Event]
    let timestamp: Date
    
    init(events: [Event], timestamp: Date) {
        self.events = events
        self.timestamp = timestamp
    }
}