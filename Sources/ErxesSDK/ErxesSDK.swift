import UIKit
import SwiftUI

@MainActor
public final class ErxesSDK {
    public static let shared = ErxesSDK()

    private(set) var config: ErxesConfig?
    private(set) var currentUser: ErxesUser?

    private init() {}

    /// Call once at app startup before showing the messenger.
    public static func configure(_ config: ErxesConfig) {
        shared.config = config
        NetworkClient.shared.configure(endpoint: config.endpoint)
    }

    /// Set the logged-in user so conversations are linked to them.
    public static func setUser(_ user: ErxesUser) {
        shared.currentUser = user
    }

    /// Clear the current user (e.g. on logout).
    public static func clearUser() {
        shared.currentUser = nil
    }

    /// Present the messenger modally from any view controller.
    public static func showMessenger(from viewController: UIViewController) {
        guard let config = shared.config else {
            assertionFailure("ErxesSDK.configure() must be called before showMessenger()")
            return
        }
        let root = MessengerContainerView(config: config, user: shared.currentUser)
        let hostingVC = UIHostingController(rootView: root)
        hostingVC.modalPresentationStyle = .pageSheet
        if let sheet = hostingVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        viewController.present(hostingVC, animated: true)
    }
}
