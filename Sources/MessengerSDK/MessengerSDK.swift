import UIKit
import SwiftUI
import Combine

@MainActor
public final class MessengerSDK: ObservableObject {
    public static let shared = MessengerSDK()

    private(set) var config: MessengerConfig?
    private(set) var currentUser: MessengerUser?

    /// True once the initial connect handshake succeeds.
    /// Observe this to show/hide your launcher button.
    @Published public private(set) var isReady = false

    /// Invoked when a chat-mode action (a `homeActions`/`drawerActions` item) is
    /// tapped, with the action's `id`. The React Native bridge wires this to a JS
    /// event; native hosts can set it directly.
    public var onAction: ((String) -> Void)?

    /// The cached AppViewModel reused across sheet presentations.
    private var appVM: AppViewModel?

    /// The currently presented messenger controller (chat full-screen or classic
    /// sheet), tracked weakly so a host can dismiss it via `hideMessenger()`.
    private weak var presentedMessengerVC: UIViewController?

    /// Chat-mode controller retained across hide/show so its SwiftUI `@State`
    /// (active conversation, drafts, drawer) survives a `hideMessenger()` /
    /// `showMessenger()` cycle. Without this, re-presenting builds a fresh view
    /// that resets to the new-chat home — the visible "back to initial" flash.
    /// Held strongly (unlike `presentedMessengerVC`) so the dismissed controller
    /// isn't deallocated while hidden. Cleared on `configure()`.
    private var cachedChatVC: UIViewController?

    private init() {}

    // MARK: - Configuration

    /// Call once at app startup. Automatically starts the connect handshake.
    public static func configure(_ config: MessengerConfig) {
        shared.config = config
        shared.didAutoPresentChat = false
        // New configuration = a fresh messenger; drop any retained chat view so
        // it rebuilds against the new config instead of restoring stale state.
        shared.cachedChatVC = nil
        // Auto-connect so launcher appears (or chat mode auto-opens) as soon as
        // the handshake succeeds.
        startConnect()
    }

    /// Set the logged-in user so conversations are linked to them.
    public static func setUser(_ user: MessengerUser) {
        shared.currentUser = user
    }

    /// Clear the current user on logout. Drops the in-memory user *and* the persisted
    /// identity (cachedCustomerId, conversation, visitorId, …) so the next connect
    /// starts as a fresh anonymous visitor rather than re-identifying the logged-out
    /// customer and surfacing their old conversations.
    public static func clearUser() {
        shared.currentUser = nil
        SessionManager.shared.clearIdentity()
    }

    // MARK: - Floating launcher (native overlay)

    /// Present the floating launcher in a transparent overlay window above the host
    /// app's content. Use this from non-SwiftUI hosts (UIKit, React Native, Flutter).
    /// The button only appears once the connect handshake succeeds (`isReady`), and
    /// touches outside the button pass straight through to your app.
    ///
    /// In `.chat` mode there is no floating launcher — the messenger opens itself
    /// full-screen as soon as the connect handshake succeeds, so this is a no-op.
    public static func showLauncher() {
        guard shared.config?.displayMode != .chat else { return }
        LauncherWindow.shared.show()
    }

    /// Remove the floating launcher overlay window.
    public static func hideLauncher() {
        LauncherWindow.shared.hide()
    }

    /// Dismiss the presented messenger — the full-screen chat shell or the classic
    /// sheet — if one is up. Use this to close the messenger from a host-handled
    /// action (e.g. a chat-mode `homeActions` "close" button), since launcher-less
    /// chat mode has no built-in close control. No-op if nothing is presented.
    ///
    /// A subsequent `configure()` (e.g. revisiting the screen) re-opens chat mode.
    ///
    /// In chat mode the dismissed controller is kept in `cachedChatVC`, so a later
    /// `showMessenger()` restores the exact screen the user left rather than
    /// resetting to the new-chat home.
    public static func hideMessenger() {
        guard let vc = shared.presentedMessengerVC else { return }
        vc.dismiss(animated: true)
        shared.presentedMessengerVC = nil
    }

    // MARK: - Internal connect

    private static func startConnect() {
        guard let config = shared.config else { return }
        let vm = AppViewModel()
        shared.appVM = vm
        // Chat mode is a full-screen, app-like experience — present it right away
        // (it fades in) and show a loading indicator inside until the handshake
        // completes, rather than blocking on the network or a launcher tap.
        if config.displayMode == .chat {
            autoPresentChatModeIfNeeded()
        }
        Task { @MainActor in
            await vm.connect(config: config, user: shared.currentUser)
            shared.isReady = true
        }
    }

    // MARK: - Chat-mode auto-present

    /// Guards against re-presenting chat mode after the host dismisses it.
    private var didAutoPresentChat = false

    /// Presents chat mode full-screen from the app's own window. The window may not
    /// exist yet right after `configure()` (e.g. called from `App.init`), so this
    /// retries briefly until a presentable view controller is available.
    @MainActor
    private static func autoPresentChatModeIfNeeded(retriesLeft: Int = 20) {
        guard shared.config?.displayMode == .chat,
              let vm = shared.appVM,
              !shared.didAutoPresentChat else { return }

        guard let presenter = topViewController(from: appPresentationWindow()?.rootViewController) else {
            // No window/root yet — try again shortly (stays on the main actor).
            guard retriesLeft > 0 else { return }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 250_000_000)
                autoPresentChatModeIfNeeded(retriesLeft: retriesLeft - 1)
            }
            return
        }
        // Don't stack on top of an already-presented messenger.
        guard presenter.presentedViewController == nil else { return }

        shared.didAutoPresentChat = true
        present(vm, from: presenter, onDismiss: nil)
    }

    // MARK: - Show messenger

    /// Present the messenger. Uses the already-connected AppViewModel — opens instantly.
    public static func showMessenger(from viewController: UIViewController, onDismiss: (() -> Void)? = nil) {
        guard let config = shared.config else {
            assertionFailure("MessengerSDK.configure() must be called before showMessenger()")
            return
        }

        // If already ready use cached VM; otherwise connect fresh
        if let vm = shared.appVM, shared.isReady {
            present(vm, from: viewController, onDismiss: onDismiss)
        } else {
            let vm = shared.appVM ?? AppViewModel()
            shared.appVM = vm
            Task { @MainActor in
                await vm.connect(config: config, user: shared.currentUser)
                shared.isReady = true
                present(vm, from: viewController, onDismiss: onDismiss)
            }
        }
    }

    private static func present(
        _ appVM: AppViewModel,
        from viewController: UIViewController,
        onDismiss: (() -> Void)?
    ) {
        // The launcher button lives in its own overlay window. Tapping it can make
        // that window key, so the caller may hand us a presenter that lives inside
        // it — presenting from there (and then hiding it) would put the sheet in a
        // hidden window. Redirect to the app's own window in that case.
        let presenter = safePresenter(viewController)

        let isChatMode = shared.config?.displayMode == .chat

        // Re-presenting after a hide: reuse the retained chat-mode controller so
        // SwiftUI `@State` survives and the user returns to the exact screen they
        // left — no rebuild, no reset to the new-chat home. `presentingViewController`
        // is nil once the previous dismiss completed, confirming it's free to show.
        if isChatMode,
           let cached = shared.cachedChatVC,
           cached.presentingViewController == nil {
            shared.presentedMessengerVC = cached
            presenter.present(cached, animated: true)
            return
        }

        // Hide the floating launcher while the sheet is up so it doesn't overlay it,
        // and restore it on dismiss only if it was visible to begin with.
        let launcherWasVisible = LauncherWindow.shared.isVisible
        LauncherWindow.shared.suspend()

        // Chat mode is a full-screen app-like experience; the classic widget is a
        // large sheet with a grabber. Build the matching root view for each.
        let hostingVC: DismissCallbackHostingController<AnyView> = {
            let onDismissAll: () -> Void = {
                if launcherWasVisible { LauncherWindow.shared.resume() }
                onDismiss?()
            }
            if isChatMode {
                return DismissCallbackHostingController(
                    rootView: AnyView(
                        MessengerChatModeView(appVM: appVM, showsCloseButton: launcherWasVisible)
                    ),
                    onDismiss: onDismissAll
                )
            }
            return DismissCallbackHostingController(
                rootView: AnyView(MessengerContainerView(appVM: appVM)),
                onDismiss: onDismissAll
            )
        }()

        if isChatMode {
            // Full-screen with a fade (cross-dissolve) instead of the default
            // slide-up; the view shows a loading indicator until connected.
            hostingVC.modalPresentationStyle = .fullScreen
            hostingVC.modalTransitionStyle = .crossDissolve
        } else {
            hostingVC.modalPresentationStyle = .pageSheet
            if let sheet = hostingVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
        }
        shared.presentedMessengerVC = hostingVC
        // Retain the chat-mode controller for reuse on the next show (see top of
        // this method). The classic sheet is cheap to rebuild, so it isn't cached.
        if isChatMode {
            shared.cachedChatVC = hostingVC
        }
        presenter.present(hostingVC, animated: true)
    }

    // MARK: - Presenter resolution

    /// Use the caller's presenter unless it belongs to the launcher overlay window,
    /// in which case fall back to the top view controller of the app's own window.
    private static func safePresenter(_ preferred: UIViewController) -> UIViewController {
        let window = preferred.viewIfLoaded?.window
        if window != nil && !LauncherWindow.shared.owns(window) {
            return preferred
        }
        return topViewController(from: appPresentationWindow()?.rootViewController) ?? preferred
    }

    /// The app's foreground window, excluding the launcher overlay window.
    private static func appPresentationWindow() -> UIWindow? {
        let candidates = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .filter { !$0.isHidden && !LauncherWindow.shared.owns($0) }
        return candidates.first { $0.isKeyWindow }
            ?? candidates.first { $0.windowLevel == .normal }
            ?? candidates.first
    }

    private static func topViewController(from root: UIViewController?) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return topViewController(from: nav.visibleViewController)
        }
        if let tab = root as? UITabBarController {
            return topViewController(from: tab.selectedViewController)
        }
        if let presented = root?.presentedViewController {
            return topViewController(from: presented)
        }
        return root
    }
}

// MARK: - Hosting controller that fires a callback on dismiss

private final class DismissCallbackHostingController<Content: View>: UIHostingController<Content> {
    private let onDismiss: (() -> Void)?

    init(rootView: Content, onDismiss: (() -> Void)?) {
        self.onDismiss = onDismiss
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder: NSCoder) { fatalError() }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed { onDismiss?() }
    }
}
