import UIKit

public struct ErxesConfig {
    /// Base URL of your erxes server  e.g. "https://app.erxes.io"
    public let endpoint: String

    /// Integration ID from erxes dashboard → Settings → Integrations → iOS App
    public let integrationId: String

    /// Optional: cached customer ID from a previous session (persisted in Keychain)
    public var cachedCustomerId: String?

    public var appearance: Appearance

    public init(
        endpoint: String,
        integrationId: String,
        cachedCustomerId: String? = nil,
        appearance: Appearance = .init()
    ) {
        self.endpoint = endpoint
        self.integrationId = integrationId
        self.cachedCustomerId = cachedCustomerId
        self.appearance = appearance
    }

    public struct Appearance {
        public var primaryColor: UIColor
        public var launcherIcon: UIImage?

        public init(
            primaryColor: UIColor = UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1),
            launcherIcon: UIImage? = nil
        ) {
            self.primaryColor = primaryColor
            self.launcherIcon = launcherIcon
        }
    }
}
