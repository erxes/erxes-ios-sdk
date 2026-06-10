import SwiftUI

/// Compact gradient hero header used by Messages and Tickets tabs.
/// Matches the Home hero aesthetic (radial glows, safe-area aware) at ~half the height.
struct PageHeroHeader: View {
    @EnvironmentObject var appVM: AppViewModel

    let title: String
    let subtitle: String

    var body: some View {
        let primary   = Color(appVM.effectivePrimaryColor)
        let bg        = Color(appVM.effectiveBackgroundColor)
        let textColor = Color(appVM.effectiveTextColor)

        ZStack(alignment: .top) {
            // ── Gradient background ───────────────────────────────────────────
            GeometryReader { geo in
                headerBackground(bg: bg, primary: primary, size: geo.size)
            }
            .ignoresSafeArea(edges: .top)

            // ── Content ───────────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(textColor.opacity(0.60))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Background

    @ViewBuilder
    private func headerBackground(bg: Color, primary: Color, size: CGSize) -> some View {
        let r = max(size.width, size.height)
        ZStack {
            bg.ignoresSafeArea()

            // Primary glow — top-right
            RadialGradient(
                colors: [primary.opacity(0.50), .clear],
                center: UnitPoint(x: 1.2, y: -0.1),
                startRadius: 0,
                endRadius: r * 0.90
            )
            .blendMode(.plusLighter)

            // Warm accent — bottom-left
            RadialGradient(
                colors: [Color(red: 0.85, green: 0.25, blue: 0.35).opacity(0.25), .clear],
                center: UnitPoint(x: -0.15, y: 1.2),
                startRadius: 0,
                endRadius: r * 0.70
            )
            .blendMode(.plusLighter)

            // Bottom fade so content blends in cleanly
            LinearGradient(
                colors: [.clear, bg.opacity(0.70)],
                startPoint: UnitPoint(x: 0.5, y: 0.45),
                endPoint: .bottom
            )
        }
        .frame(width: size.width, height: size.height)
    }
}
