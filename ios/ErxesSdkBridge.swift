import Foundation
import UIKit
import MessengerSDK

/// Thin `@objc` bridge over the pure-Swift `MessengerSDK` so the Objective-C++
/// TurboModule can call into it. All calls hop to the main actor because the SDK
/// is `@MainActor`-isolated and touches UIKit (the launcher window).
@objc(ErxesSdkBridge)
public final class ErxesSdkBridge: NSObject {

    /// Set by the Objective-C++ TurboModule. Invoked (on the main thread) whenever
    /// a chat-mode action is tapped, with the action's `id`, so the module can emit
    /// the `onAction` event to JS.
    @objc public var onAction: ((String) -> Void)?

    @objc
    public func configure(_ config: [String: Any]) {
        let integrationId = config["integrationId"] as? String ?? ""
        let serverUrl = config["serverUrl"] as? String ?? ""
        let fileEndpoint = config["fileEndpoint"] as? String
        let primaryHex = config["primaryColor"] as? String

        let appearance = MessengerConfig.Appearance(
            primaryColor: Self.color(fromHex: primaryHex) ?? MessengerConfig.Appearance().primaryColor
        )

        let displayMode = DisplayMode(rawValue: config["displayMode"] as? String ?? "") ?? .classic
        let homeActions = Self.actions(config["homeActions"])
        let drawerActions = Self.actions(config["drawerActions"])

        DispatchQueue.main.async {
            MessengerSDK.configure(
                MessengerConfig(
                    endpoint: serverUrl,
                    integrationId: integrationId,
                    fileEndpoint: fileEndpoint,
                    appearance: appearance,
                    displayMode: displayMode,
                    homeActions: homeActions,
                    drawerActions: drawerActions
                )
            )
            // Forward SDK action taps to JS via the TurboModule's event emitter.
            MessengerSDK.shared.onAction = { [weak self] id in
                self?.onAction?(id)
            }
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

    @objc
    public func hideMessenger() {
        DispatchQueue.main.async { MessengerSDK.hideMessenger() }
    }

    // MARK: - Helpers

    /// Parses an array of `{ id, title, systemIcon }` dictionaries from JS into
    /// `ActionItem`s, skipping any entry missing an `id` or `systemIcon`.
    private static func actions(_ raw: Any?) -> [ActionItem] {
        guard let arr = raw as? [[String: Any]] else { return [] }
        return arr.compactMap { d in
            guard let id = d["id"] as? String,
                  let icon = d["systemIcon"] as? String else { return nil }
            return ActionItem(id: id, title: d["title"] as? String ?? "", systemIcon: icon)
        }
    }

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
