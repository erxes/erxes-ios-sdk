import UIKit
import SwiftUI

/// A transparent overlay `UIWindow` that floats the `MessengerLaunchButton` above
/// the host app's content. Used by non-SwiftUI hosts (UIKit, React Native, Flutter)
/// that can't simply add `MessengerLaunchButton` as a SwiftUI `.overlay`.
///
/// The window passes through every touch except the ones that land on the button,
/// so it never blocks interaction with the app underneath.
@MainActor
final class LauncherWindow {

    static let shared = LauncherWindow()
    private init() {}

    private var window: PassthroughWindow?

    /// Present the floating launcher. Idempotent — calling twice is a no-op.
    /// Visibility of the button itself is still gated by `MessengerSDK.shared.isReady`,
    /// so the window can be shown immediately at configure time.
    func show() {
        guard window == nil else { return }
        guard let scene = Self.activeWindowScene else { return }

        let window = PassthroughWindow(windowScene: scene)
        window.windowLevel = .normal + 1          // just above the app's main window
        window.backgroundColor = .clear

        let host = UIHostingController(rootView: LauncherOverlay())
        host.view.backgroundColor = .clear
        window.rootViewController = host

        window.isHidden = false
        self.window = window
    }

    /// Remove the launcher window entirely.
    func hide() {
        window?.isHidden = true
        window = nil
    }

    private static var activeWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    }
}

// MARK: - Overlay content

/// Fills the window, shows the launch button once the SDK handshake completes.
private struct LauncherOverlay: View {
    @ObservedObject private var sdk = MessengerSDK.shared

    var body: some View {
        Color.clear
            .overlay {
                if sdk.isReady {
                    MessengerLaunchButton()
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: sdk.isReady)
    }
}

// MARK: - Pass-through window

/// A window that only "catches" touches on its subviews (the button). Touches that
/// land on the empty root view return `nil` from `hitTest`, so UIKit forwards them
/// to the window underneath — the host app stays fully interactive.
private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hit = super.hitTest(point, with: event) else { return nil }
        // The root view controller's own view is the transparent background — let
        // those touches fall through. Anything else is real launcher UI.
        return rootViewController?.view === hit ? nil : hit
    }
}
