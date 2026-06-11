import Foundation
import UIKit
import MessengerSDK

/// Thin `@objc` bridge over the pure-Swift `MessengerSDK` so the Objective-C++
/// TurboModule can call into it. All calls hop to the main actor because the SDK
/// is `@MainActor`-isolated and touches UIKit (the launcher window).
@objc(ErxesSdkBridge)
public final class ErxesSdkBridge: NSObject {

    @objc
    public func configure(_ config: [String: Any]) {
        let integrationId = config["integrationId"] as? String ?? ""
        let serverUrl = config["serverUrl"] as? String ?? ""
        let fileEndpoint = config["fileEndpoint"] as? String
        let primaryHex = config["primaryColor"] as? String

        let appearance = MessengerConfig.Appearance(
            primaryColor: Self.color(fromHex: primaryHex) ?? MessengerConfig.Appearance().primaryColor
        )

        DispatchQueue.main.async {
            MessengerSDK.configure(
                MessengerConfig(
                    endpoint: serverUrl,
                    integrationId: integrationId,
                    fileEndpoint: fileEndpoint,
                    appearance: appearance
                )
            )
        }
    }

    @objc
    public func setUser(_ user: [String: Any]) {
        let email = user["email"] as? String
        let phone = user["phone"] as? String
        let name = user["name"] as? String
        DispatchQueue.main.async {
            MessengerSDK.setUser(MessengerUser(email: email, phone: phone, name: name))
        }
    }

    @objc
    public func clearUser() {
        DispatchQueue.main.async { MessengerSDK.clearUser() }
    }

    @objc
    public func showLauncher() {
        DispatchQueue.main.async { MessengerSDK.showLauncher() }
    }

    @objc
    public func hideLauncher() {
        DispatchQueue.main.async { MessengerSDK.hideLauncher() }
    }

    // MARK: - Helpers

    private static func color(fromHex hex: String?) -> UIColor? {
        guard var s = hex?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6, let value = UInt32(s, radix: 16) else { return nil }
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255,
            green: CGFloat((value & 0x00FF00) >> 8) / 255,
            blue: CGFloat(value & 0x0000FF) / 255,
            alpha: 1
        )
    }
}
