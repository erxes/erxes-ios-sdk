import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    let onStartConversation: () -> Void
    var onOpenTickets: () -> Void = {}

    var body: some View {
        let primary = Color(appVM.effectivePrimaryColor)

        ScrollView {
            VStack(spacing: 0) {
                heroSection(primary: primary)
                cardsSection(primary: primary)
                    .padding(.top, 16)
                // iOS 16-17: extra space to clear the overlaid custom tab bar + input bar
                // iOS 18+: native TabView handles safe area automatically (safeAreaInset adds extra)
                Spacer().frame(height: 20)
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Hero

    // Dark base color: --color-hero  (deep navy)
    private let heroColor = Color(red: 0.05, green: 0.07, blue: 0.14)
    // Hero darkened ~30% toward black: color-mix(in oklch, hero 70%, black)
    private let heroDark  = Color(red: 0.03, green: 0.04, blue: 0.09)
    // --color-destructive
    private let destructiveColor = Color(red: 0.90, green: 0.22, blue: 0.22)

    private func heroSection(primary: Color) -> some View {
        ZStack(alignment: .top) {
            // ── Background: matches the web CSS ──────────────────────────────
            // radial(60% 50% at 80% 20%, primary*0.55 → transparent)
            // radial(60% 60% at 15% 110%, destructive*0.45 → transparent)
            // linear(180deg, hero → hero*0.7+black)
            GeometryReader { geo in
                heroGradientBackground(primary: primary, size: geo.size)
            }

            // ── Content ───────────────────────────────────────────────────────
            VStack(spacing: 0) {
                // Top bar  (pt-4.5 ≈ 18 pt)
                HStack(alignment: .center) {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 36, height: 36)
                        .overlay {
                            Image(systemName: "bubble.left.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 15))
                        }
                    Spacer()
                    SupportersRow(size: 28)
                }
                .padding(.horizontal, 20)   // px-5
                .padding(.top, 18)          // pt-4.5

                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hi 👋 Welcome to erxes")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    Text(appVM.messengerData?.messages?.greet
                         ?? "Get answers on pricing, deployment, and migration. AI agent replies in seconds")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)

                // Auto-message bubble
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                    Text(appVM.messengerData?.messages?.welcome
                         ?? "Hi 👋 Ask us anything about erxes XOS. Our AI agent replies now; the team joins for deeper questions.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .liquidGlass(
                    tint: .white.opacity(0.10),
                    shape: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 48)       // pb-12
            }
        }
        .frame(minHeight: 160)              // min-h-40 = 160 pt
        .clipped()
    }

    /// Replicates the web CSS three-layer gradient:
    /// 1. linear-gradient(180deg, hero → heroDark)
    /// 2. radial at (80%, 20%)  — primary tint, 60%×50% ellipse
    /// 3. radial at (15%, 110%) — destructive tint, 60%×60% ellipse
    @ViewBuilder
    private func heroGradientBackground(primary: Color, size: CGSize) -> some View {
        ZStack {
            // Layer 1 — base linear
            LinearGradient(
                colors: [heroColor, heroDark],
                startPoint: .top,
                endPoint: .bottom
            )

            // Layer 2 — primary radial, top-right (80%, 20%)
            // CSS: 60% wide, 50% tall → endRadius = half of those dimensions
            RadialGradient(
                colors: [primary.opacity(0.55), .clear],
                center: .center,
                startRadius: 0,
                endRadius: size.width * 0.3   // half of 60% width
            )
            .scaleEffect(
                x: 1.0,
                y: (size.height * 0.50) / (size.width * 0.60)  // squish to 50% tall
            )
            .frame(width: size.width * 0.60, height: size.height * 0.50)
            .position(x: size.width * 0.80, y: size.height * 0.20)

            // Layer 3 — destructive radial, bottom-left (15%, 110%)
            // CSS: 60% wide, 60% tall
            RadialGradient(
                colors: [destructiveColor.opacity(0.45), .clear],
                center: .center,
                startRadius: 0,
                endRadius: size.width * 0.3   // half of 60% width
            )
            .scaleEffect(
                x: 1.0,
                y: (size.height * 0.60) / (size.width * 0.60)  // squish to 60% tall
            )
            .frame(width: size.width * 0.60, height: size.height * 0.60)
            .position(x: size.width * 0.15, y: size.height * 1.10)
        }
        .frame(width: size.width, height: size.height)
    }

    // MARK: - Cards

    private func cardsSection(primary: Color) -> some View {
        GlassContainer {
            VStack(spacing: 12) {
                // Ask a question
                glassCard(action: onStartConversation) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ask a question").font(.headline)
                            Text("AI Agent and team can help")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        SupportersRow(size: 26)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary).font(.system(size: 14, weight: .semibold))
                    }
                }

                // Need help / availability
                needHelpCard

                // Tickets
                glassCard(action: onOpenTickets) {
                    HStack(spacing: 14) {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .frame(width: 40, height: 40)
                            .background(Color(.systemGray5), in: Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TICKETS")
                                .font(.caption.weight(.bold)).foregroundStyle(.secondary)
                            Text("Issue a ticket").font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary).font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var needHelpCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Need help?").font(.headline)
            (Text("We're available between ")
                .foregroundColor(.secondary)
            + Text("9.00 pm and 3.00 am(GMT +8)")
                .fontWeight(.semibold)
            + Text(", everyday.")
                .foregroundColor(.secondary))
            .font(.subheadline)
            Text("Contact us for any questions or concerns.")
                .font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 14) {
                ForEach(["facebook", "instagram", "x", "youtube"], id: \.self) { name in
                    Image(name, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlass(
            shape: RoundedRectangle(cornerRadius: 20, style: .continuous),
            shadowRadius: 4
        )
    }

    // MARK: - Glass card helper

    private func glassCard<Content: View>(action: @escaping () -> Void, @ViewBuilder content: () -> Content) -> some View {
        Button(action: action) {
            content()
                .padding(16)
                .frame(maxWidth: .infinity)
                .liquidGlassCard(cornerRadius: 20)
        }
        .foregroundStyle(.primary)
    }
}

// MARK: - Supporters row (reusable)

struct SupportersRow: View {
    @EnvironmentObject var appVM: AppViewModel
    let size: CGFloat

    private let maxVisible = 2

    var body: some View {
        let shown = Array(appVM.supporters.prefix(maxVisible))
        let extra = appVM.supporters.count - shown.count

        HStack(alignment: .center, spacing: -size * 0.25) {
            ForEach(shown) { supporter in
                AvatarWithStatusView(
                    avatarKey: supporter.avatar,
                    isOnline: supporter.isOnline,
                    size: size
                )
                .overlay(Circle().stroke(Color(.systemBackground).opacity(0.4), lineWidth: 1.5))
            }

            // "+N" bubble if there are more
            if extra > 0 {
                Text("+\(extra)")
                    .font(.system(size: size * 0.38, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: size, height: size)
                    .background(.secondary, in: Circle())
                    .overlay(Circle().stroke(Color(.systemBackground).opacity(0.4), lineWidth: 1.5))
            }
        }
        .frame(height: size)  // fixes vertical alignment in parent HStack
    }
}
