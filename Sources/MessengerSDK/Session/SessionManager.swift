import Foundation

/// Persists visitor/customer identity across app launches.
/// Mirrors RN SDK's AsyncStorage usage for cachedCustomerId + visitorId.
final class SessionManager {
    static let shared = SessionManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private enum Key {
        static let customerId = "messenger.cachedCustomerId"
        static let visitorId  = "messenger.visitorId"
        static let conversationId = "messenger.conversationId"
    }

    // MARK: - Customer ID (set after successful connect mutation)
    var cachedCustomerId: String? {
        get { defaults.string(forKey: Key.customerId) }
        set { defaults.set(newValue, forKey: Key.customerId) }
    }

    // MARK: - Visitor ID (generated once for anonymous users, reused across sessions)
    var visitorId: String {
        if let existing = defaults.string(forKey: Key.visitorId) {
            return existing
        }
        let new = ObjectIdGenerator.generate()
        defaults.set(new, forKey: Key.visitorId)
        return new
    }

    // MARK: - Last active conversation
    var lastConversationId: String? {
        get { defaults.string(forKey: Key.conversationId) }
        set { defaults.set(newValue, forKey: Key.conversationId) }
    }

    func clearCustomer() {
        defaults.removeObject(forKey: Key.customerId)
        defaults.removeObject(forKey: Key.conversationId)
    }
}
