import SwiftUI

// MARK: - Liquid Glass view modifier
// Uses iOS 26's native .glassEffect() on supported devices;
// falls back to .ultraThinMaterial on iOS 16–25.

extension View {

    /// Applies Apple Liquid Glass on iOS 26+, material blur on older OS.
    @ViewBuilder
    func liquidGlass(
        tint: Color = .clear,
        shape: some Shape = RoundedRectangle(cornerRadius: 20, style: .continuous),
        shadowRadius: CGFloat = 0
    ) -> some View {
        if #available(iOS 26, *) {
            self
                .glassEffect(
                    Glass.regular.tint(tint),
                    in: shape
                )
        } else {
            self
                .background(shape.fill(.ultraThinMaterial))
                .overlay(shape.fill(tint))
                .overlay(shape.stroke(Color.white.opacity(0.18), lineWidth: 1))
                .shadow(radius: shadowRadius)
        }
    }

    /// Interactive glass — slightly brighter, used for tappable cards/buttons.
    @ViewBuilder
    func liquidGlassCard(
        tint: Color = .clear,
        cornerRadius: CGFloat = 20
    ) -> some View {
        let s = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        if #available(iOS 26, *) {
            self.glassEffect(Glass.regular.tint(tint).interactive(), in: s)
        } else {
            self.background(s.fill(.regularMaterial))
                .overlay(s.fill(tint))
                .overlay(s.stroke(Color.white.opacity(0.16), lineWidth: 1))
                .clipShape(s)
        }
    }
}

// MARK: - Glass container wrapper
// On iOS 26 GlassEffectContainer merges neighbouring glass into one surface.
// On older OS it's a plain ZStack.
struct GlassContainer<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if #available(iOS 26, *) {
            GlassEffectContainer { content }
        } else {
            content
        }
    }
}
