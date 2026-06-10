import UIKit

public struct ConnectResponse {
    public let integrationId: String
    public let customerId: String?
    public let visitorId: String?
    public let languageCode: String?
    public let uiOptions: UIOptions
    public let messengerData: MessengerData
}

public struct UIOptions {
    public let color: String?            // brand / primary  — uiOptions.primary.DEFAULT
    public let textColor: String?        // hero text color  — uiOptions.textColor
    public let backgroundColor: String?  // hero background  — uiOptions.backgroundColor
    public let wallpaper: String?
    public let logo: String?

    public var primaryColor: UIColor {
        guard let hex = color else {
            return UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1)
        }
        return UIColor(hex: hex) ?? UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1)
    }
}

public struct MessengerData {
    public let supporterIds: [String]
    public let notifyCustomer: Bool
    public let availabilityMethod: String?   // "manual" | "auto"
    public let isOnline: Bool
    public let onlineHours: [OnlineHour]
    public let timezone: String?
    public let messages: GreetingMessages?
    public let links: SocialLinks?
    public let ticketConfig: TicketConfig?
    public let websiteApps: [WebsiteApp]
    public let responseRate: String?         // "minutes" | "hours" | "days"
    public let requireAuth: Bool
    public let showChat: Bool
    public let showLauncher: Bool
    public let forceLogoutWhenResolve: Bool
    public let showVideoCallRequest: Bool
}

// MARK: - Website app (messengerData.websiteApps)

public struct WebsiteApp: Identifiable {
    public let id: String
    public let kind: String
    public let buttonText: String
    public let description: String?
    public let url: String
    public let showInInbox: Bool
}

// MARK: - Ticket config (from messengerData.ticketConfig)

public struct TicketConfig {
    public let id: String
    public let name: String
    public let pipelineId: String
    public let channelId: String?
    public let selectedStatusId: String  // used as statusId in createTicket
    public let parentId: String?
    public let formFields: TicketFormFields
}

public struct TicketFormFields {
    public let name: TicketFieldConfig?
    public let description: TicketFieldConfig?
    public let attachment: TicketFieldConfig?
    public let tags: TicketFieldConfig?

    /// Visible fields sorted by their order value.
    public var visibleFields: [(key: String, config: TicketFieldConfig)] {
        [("name", name), ("description", description), ("attachment", attachment), ("tags", tags)]
            .compactMap { key, cfg in
                guard let cfg, cfg.isShow else { return nil }
                return (key, cfg)
            }
            .sorted { $0.config.order < $1.config.order }
    }
}

public struct TicketFieldConfig {
    public let isShow: Bool
    public let label: String?
    public let placeholder: String?
    public let order: Int
}

public struct TicketTag: Identifiable {
    public let id: String
    public let name: String
    public let type: String?
    public let description: String?
}

public struct OnlineHour {
    public let day: String
    public let from: String
    public let to: String
}

public struct GreetingMessages {
    public let greetTitle: String?   // greetings.title
    public let greet: String?        // greetings.message (subtitle)
    public let away: String?
    public let thank: String?
    public let welcome: String?
}

public struct SocialLinks {
    public let facebook: String?
    public let instagram: String?
    public let twitter: String?    // "x" / twitter
    public let youtube: String?
    public let linkedin: String?
    public let discord: String?
    public let github: String?

    /// Returns (imageName, url) pairs for links that have a value.
    public var available: [(name: String, url: String)] {
        [
            ("facebook",  facebook),
            ("instagram", instagram),
            ("x",         twitter),
            ("youtube",   youtube),
            ("linkedin",  linkedin),
            ("discord",   discord),
        ].compactMap { name, url in
            guard let url, !url.isEmpty else { return nil }
            return (name, url)
        }
    }
}

// MARK: - UIColor hex helper
extension UIColor {
    convenience init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("#") { cleaned = String(cleaned.dropFirst()) }
        guard cleaned.count == 6, let value = UInt64(cleaned, radix: 16) else { return nil }
        self.init(
            red:   CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8)  & 0xFF) / 255,
            blue:  CGFloat( value        & 0xFF) / 255,
            alpha: 1
        )
    }
}
