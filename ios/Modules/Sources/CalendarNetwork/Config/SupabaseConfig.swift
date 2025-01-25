import Foundation

public struct SupabaseConfig {
    let url: URL
    let apiKey: String
    
    static func load() -> SupabaseConfig {
        guard let path = Bundle.main.path(forResource: "Supabase", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let urlString = dict["SUPABASE_URL"] as? String,
              let url = URL(string: urlString),
              let apiKey = dict["SUPABASE_API_KEY"] as? String
        else {
            fatalError("Supabase configuration not found")
        }
        return SupabaseConfig(url: url, apiKey: apiKey)
    }
}