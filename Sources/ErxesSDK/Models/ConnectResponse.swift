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
    public let color: String?
    public let wallpaper: String?
    public let logo: String?
    public let backgroundColor: String?   // e.g. "#000"

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
    public let requireAuth: Bool
    public let showChat: Bool
    public let showLauncher: Bool
    public let forceLogoutWhenResolve: Bool
    public let showVideoCallRequest: Bool
}

public struct OnlineHour {
    public let day: String
    public let from: String
    public let to: String
}

public struct GreetingMessages {
    public let greet: String?
    public let away: String?
    public let thank: String?
    public let welcome: String?
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
