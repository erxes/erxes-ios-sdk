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

    /// Whether the launcher overlay is currently on screen.
    var isVisible: Bool { window?.isHidden == false }

    /// Temporarily hide the launcher without tearing down the window — used while the
    /// messenger sheet is presented so the button doesn't float over it. Pair with
    /// `resume()`. No-op when the launcher isn't shown.
    func suspend() { window?.isHidden = true }

    /// Restore a launcher hidden by `suspend()`.
    func resume() { window?.isHidden = false }

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
        // The full-screen background must NOT capture touches, otherwise SwiftUI's
        // hosting view claims every point and the window can't tell the button apart
        // from empty space. With it non-interactive, the hosting view hit-tests to
        // `nil` over empty areas and to the button only where the button is drawn.
        Color.clear
            .allowsHitTesting(false)
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

/// A window that only "catches" touches on the launcher button. The hosting view
/// runs SwiftUI's own hit testing — because the background is marked non-interactive
/// it returns `nil` for the transparent areas and the hosting view only where the
/// button is drawn. We forward that result directly: button taps are delivered, and
/// every other touch falls through to the app window underneath.
///
/// NOTE: we must NOT special-case `rootViewController.view` here. SwiftUI flattens
/// the button into the single `_UIHostingView` (which *is* the root view), so doing
/// so would discard the button's own taps.
private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        // Over empty space the hosting view hit-tests to `nil`, so UIWindow falls
        // back to returning itself — treat that as a pass-through. Anywhere SwiftUI
        // claims the point (the button) it returns the hosting view, which we deliver.
        return hit === self ? nil : hit
    }
}
