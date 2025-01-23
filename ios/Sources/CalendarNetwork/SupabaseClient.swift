import Foundation
import Supabase

public final class SupabaseClient {
    private let client: SupabaseClient
    
    public static let shared = SupabaseClient()
    
    private init() {
        // These will come from configuration/environment
        client = SupabaseClient(
            supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
            supabaseKey: "YOUR_SUPABASE_KEY"
        )
    }
    
    public func getClient() -> SupabaseClient {
        return client
    }
}