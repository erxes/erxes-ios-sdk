import UIKit

/// Which UI shell the messenger presents.
public enum DisplayMode: String {
    /// The classic 4-tab widget (Home / Messages / Help / Tickets), shown as a sheet.
    case classic
    /// A ChatGPT/Claude-style shell: new-chat home, a left drawer holding the
    /// conversation list, and inline full-screen chats. Presented full-screen.
    case chat
}

/// A host-configurable action rendered in chat mode (header-right or drawer top).
/// Tapping it fires `MessengerSDK.shared.onAction` with the action's `id` — kept
/// data-only (no closures) so it can be passed across the React Native bridge.
public struct ActionItem: Identifiable {
    /// Host-defined identifier, echoed back in `onAction`.
    public let id: String
    /// Display title (used for drawer rows; accessibility label for header icons).
    public let title: String
    /// SF Symbol name, e.g. "magnifyingglass".
    public let systemIcon: String

    public init(id: String, title: String, systemIcon: String) {
        self.id = id
        self.title = title
        self.systemIcon = systemIcon
    }
}

public struct MessengerConfig {
    /// Base URL of your server  e.g. "https://app.example.io"
    public let endpoint: String

    /// Integration ID from the dashboard → Settings → Integrations → iOS App
    public let integrationId: String

    /// Base URL for serving files (avatars, attachments).
    /// Defaults to `endpoint`. Override only if your file server differs.
    public let fileEndpoint: String

    /// Optional: cached customer ID from a previous session (persisted in Keychain)
    public var cachedCustomerId: String?

    public var appearance: Appearance

    /// Which UI shell to present. Defaults to `.classic` so existing hosts are unaffected.
    public var displayMode: DisplayMode

    /// Chat-mode header-right actions (rendered as icon buttons). Ignored in `.classic`.
    public var homeActions: [ActionItem]

    /// Chat-mode drawer top action rows. Ignored in `.classic`.
    public var drawerActions: [ActionItem]

    public init(
        endpoint: String,
        integrationId: String,
        fileEndpoint: String? = nil,
        cachedCustomerId: String? = nil,
        appearance: Appearance = .init(),
        displayMode: DisplayMode = .classic,
        homeActions: [ActionItem] = [],
        drawerActions: [ActionItem] = []
    ) {
        self.endpoint = endpoint
        self.integrationId = integrationId
        self.fileEndpoint = fileEndpoint ?? endpoint
        self.cachedCustomerId = cachedCustomerId
        self.appearance = appearance
        self.displayMode = displayMode
        self.homeActions = homeActions
        self.drawerActions = drawerActions
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
