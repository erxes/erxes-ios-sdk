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
        static let integrationId = "messenger.integrationId"
        static let identified = "messenger.identified"
    }

    // MARK: - Identity capture (requireAuth)
    /// True once the visitor has supplied an email/phone via the requireAuth form,
    /// so we don't ask again on subsequent conversations. Cleared per integration.
    var isIdentified: Bool {
        get { defaults.bool(forKey: Key.identified) }
        set { defaults.set(newValue, forKey: Key.identified) }
    }

    // MARK: - Integration binding
    /// The integration the persisted identity belongs to. Identity (customer /
    /// visitor / conversation) is meaningless across integrations, so switching
    /// integrations must reset it — otherwise the new integration inherits the
    /// previous one's customerId and shows its conversations/tickets.
    private var boundIntegrationId: String? {
        get { defaults.string(forKey: Key.integrationId) }
        set { defaults.set(newValue, forKey: Key.integrationId) }
    }

    /// Call before reading any identity. Clears the persisted customer/visitor/
    /// conversation when the integration has changed since they were stored.
    func bind(integrationId: String) {
        guard boundIntegrationId != integrationId else { return }
        defaults.removeObject(forKey: Key.customerId)
        defaults.removeObject(forKey: Key.visitorId)
        defaults.removeObject(forKey: Key.conversationId)
        defaults.removeObject(forKey: Key.identified)
        boundIntegrationId = integrationId
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
        defaults.removeObject(forKey: Key.identified)
    }
}
