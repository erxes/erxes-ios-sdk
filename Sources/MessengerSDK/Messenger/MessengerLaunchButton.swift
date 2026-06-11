import SwiftUI

/// A 48 × 48 floating launcher button that sticks to the right edge of the screen.
/// Drag it up or down — it snaps to either the top-right or bottom-right corner.
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
    /// Vertical margin from the top / bottom safe area edge.
    public var verticalPadding: CGFloat   = 24
    /// Button diameter.
    public var size: CGFloat = 48

    // MARK: - State

    /// true = snapped to bottom, false = snapped to top
    @State private var isAtBottom = true
    /// Live vertical translation while the user is dragging.
    @State private var dragOffsetY: CGFloat = 0
    /// Pressed-in scale for haptic feedback feel.
    @State private var isPressed = false
    /// Drives a one-time in-place scale/opacity pop when the button first appears,
    /// so the entrance happens AT the corner instead of flying in from elsewhere.
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
        GeometryReader { geo in
            button
                .scaleEffect(hasAppeared ? 1 : 0.5)
                .opacity(hasAppeared ? 1 : 0)
                .position(buttonPosition(in: geo))
                .offset(y: dragOffsetY)
                .gesture(dragGesture(in: geo))
                // Keep the resting position rock-stable: the only thing allowed to
                // animate the position is the explicit snap spring in dragGesture.
                // This stops an inherited/ambient animation from sliding the button
                // when the GeometryReader resolves its size on the first layout pass.
                .animation(nil, value: geo.size.height)
        }
        // GeometryReader fills its parent; ignore safe-area so position()
        // works in full-screen coordinates.
        .ignoresSafeArea()
        .allowsHitTesting(true)
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
                Image("glyph", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.55, height: size * 0.55)
            }
        }
        .buttonStyle(LaunchButtonStyle(isPressed: isPressed))
        .simultaneousGesture(
            // Track press state for the scale animation without blocking the tap.
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }

    // MARK: - Position helpers

    private func buttonPosition(in geo: GeometryProxy) -> CGPoint {
        let x = geo.size.width - horizontalPadding - size / 2

        // geo.safeAreaInsets.bottom already includes the home indicator height
        // (~34 pt on Face ID devices). We respect it fully so the button always
        // sits above the home bar, then add verticalPadding for extra breathing room.
        let bottomInset = max(geo.safeAreaInsets.bottom, 0)
        let yTop        = geo.safeAreaInsets.top + verticalPadding + size / 2
        let yBottom     = geo.size.height - bottomInset - verticalPadding - size / 2

        return CGPoint(x: x, y: isAtBottom ? yBottom : yTop)
    }

    // MARK: - Drag gesture

    private func dragGesture(in geo: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                dragOffsetY = value.translation.height
            }
            .onEnded { value in
                // Decide snap target based on final Y position
                let currentY = buttonPosition(in: geo).y + value.translation.height
                let midY = geo.size.height / 2
                let shouldBeAtBottom = currentY > midY

                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isAtBottom  = shouldBeAtBottom
                    dragOffsetY = 0
                }
            }
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
