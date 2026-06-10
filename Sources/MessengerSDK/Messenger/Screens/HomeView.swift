import SwiftUI
import SafariServices

struct HomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    let onStartConversation: () -> Void
    var onOpenTickets: () -> Void = {}

    @State private var webAppURL: URL?

    var body: some View {
        let primary  = Color(appVM.effectivePrimaryColor)
        let textColor = Color(appVM.effectiveTextColor)

        ScrollView {
            VStack(spacing: 0) {
                // Hero with the CTA card pinned to its bottom edge,
                // offset downward by half the card height so it sits
                // exactly on the seam between hero and cards.
                heroSection(primary: primary, textColor: textColor)
                    .overlay(alignment: .bottom) {
                        askAQuestionCard(primary: primary)
                            .padding(.horizontal, 20)
                            .offset(y: 30) // half of ~60pt card height
                    }

                cardsSection(primary: primary)
                    .padding(.top, 46) // 30 (overlap) + 16 (gap)

                Spacer().frame(height: 20)
            }
        }
        .ignoresSafeArea(edges: .top)
        // Stop the keyboard's safe-area change from reaching GeometryReader
        // inside heroSection — that was causing full gradient rebuilds on every
        // keyboard animation frame (~60 fps lag). The input bar in the parent's
        // safeAreaInset handles its own keyboard lifting independently.
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Drag scroll upward to dismiss the keyboard.
        .scrollDismissesKeyboard(.immediately)
        // Tap anywhere outside the text field to dismiss the keyboard.
        .dismissKeyboardOnTap()
    }

    // MARK: - Hero

    private func heroSection(primary: Color, textColor: Color) -> some View {
        let bg = Color(appVM.effectiveBackgroundColor)

        return ZStack(alignment: .top) {
            // ── Background ────────────────────────────────────────────────────
            GeometryReader { geo in
                heroBackground(bg: bg, primary: primary, size: geo.size)
            }
            .ignoresSafeArea(edges: .top)

            // ── Content ───────────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(appVM.messengerData?.messages?.greetTitle ?? "Hi there 👋")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(appVM.messengerData?.messages?.greet
                         ?? "Get answers on pricing, deployment, and migration.")
                        .font(.subheadline)
                        .foregroundStyle(textColor.opacity(0.65))
                        .fixedSize(horizontal: false, vertical: true)
                }

                welcomeBubble(textColor: textColor)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 52)
        }
        .frame(minHeight: 260)
    }

    // MARK: - Hero background
    // Dark base from server backgroundColor + two radial glows using UnitPoint
    // (no scaleEffect — UnitPoint handles out-of-bounds centers natively)

    @ViewBuilder
    private func heroBackground(bg: Color, primary: Color, size: CGSize) -> some View {
        ZStack {
            // 1. Base solid from server
            bg.ignoresSafeArea()

            // 2. Primary glow — top-right, large soft bloom
            RadialGradient(
                colors: [primary.opacity(0.45), .clear],
                center: UnitPoint(x: 1.15, y: -0.05),
                startRadius: 0,
                endRadius: max(size.width, size.height) * 0.85
            )
            .blendMode(.plusLighter)

            // 3. Warm accent — bottom-left edge, subtle
            RadialGradient(
                colors: [Color(red: 0.85, green: 0.25, blue: 0.35).opacity(0.30), .clear],
                center: UnitPoint(x: -0.1, y: 1.15),
                startRadius: 0,
                endRadius: max(size.width, size.height) * 0.65
            )
            .blendMode(.plusLighter)

            // 4. Bottom fade-out so cards section blends in cleanly
            LinearGradient(
                colors: [.clear, bg.opacity(0.6)],
                startPoint: UnitPoint(x: 0.5, y: 0.55),
                endPoint: .bottom
            )
        }
        .frame(width: size.width, height: size.height)
    }

    // MARK: - Welcome bubble

    private func welcomeBubble(textColor: Color) -> some View {
        Text(appVM.messengerData?.messages?.welcome
             ?? "Hi 👋 Ask us anything — our AI agent replies instantly, then the team dives in for deeper questions.")
            .font(.subheadline)
            .foregroundStyle(textColor.opacity(0.92))
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(textColor.opacity(0.10), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(textColor.opacity(0.12), lineWidth: 1)
            )
    }

    // MARK: - Team footer

    // MARK: - Ask a question card (floats at hero / cards boundary)

    private func askAQuestionCard(primary: Color) -> some View {
        Button(action: onStartConversation) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(primary)
                    .frame(width: 40, height: 40)
                    .background(primary.opacity(0.12), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("Ask a question")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("AI Agent and team can help")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                SupportersRow(size: 24)

                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .liquidGlass(
                shape: RoundedRectangle(cornerRadius: 20, style: .continuous),
                shadowRadius: 20
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Cards

    private func cardsSection(primary: Color) -> some View {
        let apps = appVM.messengerData?.websiteApps ?? []

        return VStack(alignment: .leading, spacing: 0) {
            GlassContainer {
                VStack(spacing: 12) {
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

            // ── Website apps ──────────────────────────────────────────────────
            if !apps.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("WEB APPS")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                    GlassContainer {
                        VStack(spacing: 12) {
                            ForEach(apps) { app in
                                glassCard(action: {
                                    if let url = URL(string: app.url) {
                                        webAppURL = url
                                    }
                                }) {
                                    HStack(spacing: 14) {
                                        Image(systemName: "bookmark")
                                            .font(.title3)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 40, height: 40)
                                            .background(Color(.systemGray5), in: Circle())
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(app.buttonText.uppercased())
                                                .font(.caption.weight(.bold)).foregroundStyle(.secondary)
                                            if let desc = app.description, !desc.isEmpty {
                                                Text(desc).font(.subheadline)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundStyle(.secondary).font(.system(size: 14, weight: .semibold))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .sheet(item: $webAppURL) { url in
            SafariView(url: url, backgroundColor: appVM.effectiveBackgroundColor)
                .ignoresSafeArea()
        }
    }

    private var needHelpCard: some View {
        let links = appVM.messengerData?.links
        let pairs = links?.available ?? []

        return VStack(alignment: .leading, spacing: 10) {
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

            if !pairs.isEmpty {
                HStack(spacing: 14) {
                    ForEach(pairs, id: \.name) { pair in
                        Button {
                            if let url = URL(string: pair.url) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Image(pair.name, bundle: .module)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                // Fallback: show all icons greyed out when no links configured
                HStack(spacing: 14) {
                    ForEach(["facebook", "instagram", "x", "youtube"], id: \.self) { name in
                        Image(name, bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .opacity(0.35)
                    }
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
