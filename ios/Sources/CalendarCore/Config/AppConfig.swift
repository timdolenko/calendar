import Foundation

public enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

public struct AppConfig {
    public let supabase: SupabaseConfig
    
    public static let shared = AppConfig.load()
    
    private static func load() -> AppConfig {
        guard let path = Bundle.main.path(forResource: "Config.\(Environment.current)", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let supabaseDict = dict["Supabase"] as? [String: String],
              let urlString = supabaseDict["URL"],
              let url = URL(string: urlString),
              let apiKey = supabaseDict["API_KEY"]
        else {
            fatalError("Configuration not found or invalid")
        }
        
        return AppConfig(
            supabase: SupabaseConfig(
                url: url,
                apiKey: apiKey
            )
        )
    }
}

public struct SupabaseConfig {
    public let url: URL
    public let apiKey: String
}