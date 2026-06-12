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

    /// The cached AppViewModel reused across sheet presentations.
    private var appVM: AppViewModel?

    private init() {}

    // MARK: - Configuration

    /// Call once at app startup. Automatically starts the connect handshake.
    public static func configure(_ config: MessengerConfig) {
        shared.config = config
        NetworkClient.shared.configure(endpoint: config.endpoint)
        // Auto-connect so launcher appears as soon as handshake succeeds
        startConnect()
    }

    /// Set the logged-in user so conversations are linked to them.
    public static func setUser(_ user: MessengerUser) {
        shared.currentUser = user
    }

    /// Clear the current user (e.g. on logout).
    public static func clearUser() {
        shared.currentUser = nil
    }

    // MARK: - Floating launcher (native overlay)

    /// Present the floating launcher in a transparent overlay window above the host
    /// app's content. Use this from non-SwiftUI hosts (UIKit, React Native, Flutter).
    /// The button only appears once the connect handshake succeeds (`isReady`), and
    /// touches outside the button pass straight through to your app.
    public static func showLauncher() {
        LauncherWindow.shared.show()
    }

    /// Remove the floating launcher overlay window.
    public static func hideLauncher() {
        LauncherWindow.shared.hide()
    }

    // MARK: - Internal connect

    private static func startConnect() {
        guard let config = shared.config else { return }
        let vm = AppViewModel()
        shared.appVM = vm
        Task { @MainActor in
            await vm.connect(config: config, user: shared.currentUser)
            shared.isReady = true
        }
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

        // Hide the floating launcher while the sheet is up so it doesn't overlay it,
        // and restore it on dismiss only if it was visible to begin with.
        let launcherWasVisible = LauncherWindow.shared.isVisible
        LauncherWindow.shared.suspend()

        let root = MessengerContainerView(appVM: appVM)
        let hostingVC = DismissCallbackHostingController(rootView: root) {
            if launcherWasVisible { LauncherWindow.shared.resume() }
            onDismiss?()
        }
        hostingVC.modalPresentationStyle = .pageSheet
        if let sheet = hostingVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
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
