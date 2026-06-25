import SwiftUI

/// A 48 × 48 floating launcher button pinned to the bottom-right corner of the screen.
///
/// Usage (place as an overlay on your root view):
/// ```swift
/// YourRootView()
///     .overlay(alignment: .bottomTrailing) {
///         MessengerLaunchButton()
///     }
/// ```
public struct MessengerLaunchButton: View {

    // MARK: - Configuration

    /// Horizontal margin from the screen edge.
    public var horizontalPadding: CGFloat = 16
    /// Vertical margin from the bottom safe area edge.
    public var verticalPadding: CGFloat   = 24
    /// Button diameter.
    public var size: CGFloat = 48

    // MARK: - State

    /// Pressed-in scale for haptic feedback feel.
    @State private var isPressed = false
    /// Drives a one-time in-place scale/opacity pop when the button first appears.
    @State private var hasAppeared = false

    public init(
        horizontalPadding: CGFloat = 16,
        verticalPadding:   CGFloat = 24,
        size: CGFloat = 48
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding   = verticalPadding
        self.size              = size
    }

    // MARK: - Body

    public var body: some View {
        button
            .scaleEffect(hasAppeared ? 1 : 0.5)
            .opacity(hasAppeared ? 1 : 0)
            // Pin to the bottom-trailing corner with plain padding. No GeometryReader,
            // no .position() — so the button never reacts to safe-area insets settling
            // across layout passes, which is what made it spring up and down.
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, horizontalPadding)
            .padding(.bottom, verticalPadding)
            .onAppear {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    hasAppeared = true
                }
            }
    }

    // MARK: - Button

    private var button: some View {
        Button {
            openMessenger()
        } label: {
            ZStack {
                // Purple background circle
                Circle()
                    .fill(Color(red: 124 / 255, green: 58 / 255, blue: 237 / 255))
                    .frame(width: size, height: size)

                // Glyph at ~55 % of the button size so it has breathing room
                Image("glyph", bundle: .messengerSDKResources)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.55, height: size * 0.55)
            }
        }
        .buttonStyle(LaunchButtonStyle(isPressed: isPressed))
    }

    // MARK: - Open

    private func openMessenger() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        guard let presenter = topViewController(from: keyWindow?.rootViewController) else { return }
        MessengerSDK.showMessenger(from: presenter)
    }

    private func topViewController(from root: UIViewController?) -> UIViewController? {
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

// MARK: - Button style

private struct LaunchButtonStyle: ButtonStyle {
    let isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed || isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}
