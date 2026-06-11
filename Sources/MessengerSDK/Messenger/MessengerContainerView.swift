import SwiftUI

struct MessengerContainerView: View {
    /// Pre-connected AppViewModel passed in from MessengerSDK.showMessenger
    @ObservedObject var appVM: AppViewModel
    @State private var selectedTab: AppTab = .home
    @State private var primaryColor: Color = Color(UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1))
    @State private var homeText = ""

    /// Tickets tab is only shown when the integration has a ticket pipeline
    /// configured — otherwise there's nothing to create or list against.
    private var showTickets: Bool { appVM.messengerData?.ticketConfig != nil }

    /// Help (knowledge base) tab is only shown when the integration has a
    /// knowledgeBaseTopicId configured.
    private var showHelp: Bool { appVM.showHelpTab }

    enum AppTab: Hashable, CaseIterable, Identifiable {
        case home, messages, help, tickets
        var id: Self { self }

        var label: String {
            switch self {
            case .home:     return "Home"
            case .messages: return "Messages"
            case .help:     return "Help"
            case .tickets:  return "Tickets"
            }
        }
        var icon: String {
            switch self {
            case .home:     return "house"
            case .messages: return "bubble.left"
            case .help:     return "questionmark.circle"
            case .tickets:  return "ticket"
            }
        }
        var iconFilled: String {
            switch self {
            case .home:     return "house.fill"
            case .messages: return "bubble.left.fill"
            case .help:     return "questionmark.circle.fill"
            case .tickets:  return "ticket.fill"
            }
        }
    }

    var body: some View {
        Group {
            if #available(iOS 18, *) {
                nativeTabView(primary: primaryColor)
            } else {
                legacyTabView(primary: primaryColor)
            }
        }
        .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
        // Inject colorScheme directly into the SwiftUI environment so materials
        // (ultraThinMaterial, regularMaterial, glassEffect) pick up the correct
        // dark/light appearance instead of inheriting the host app's scheme.
        .environment(\.colorScheme, appVM.effectiveColorScheme)
        .tint(primaryColor)
        .environmentObject(appVM)
        .onAppear {
            // Colors are already set (connect ran before sheet presented), just sync them
            primaryColor = Color(appVM.effectivePrimaryColor)
        }
    }

    // MARK: - iOS 18+ native TabView
    // On iOS 26 the system renders the floating liquid glass pill automatically.
    // No custom glass code needed — Apple handles it.

    @available(iOS 18, *)
    private func nativeTabView(primary: Color) -> some View {
        TabView(selection: $selectedTab) {
            SwiftUI.Tab("Home", systemImage: "house", value: AppTab.home) {
                HomeView(
                    onStartConversation: { selectedTab = .messages },
                    onOpenTickets: { selectedTab = .tickets },
                    onOpenHelp: { selectedTab = .help }
                )
                .environmentObject(appVM)
                // Input bar sits above the tab bar, inside the home tab's safe area
                .safeAreaInset(edge: .bottom) {
                    homeInputBar(primary: primary)
                }
            }

            SwiftUI.Tab("Messages", systemImage: "bubble.left", value: AppTab.messages) {
                MessagesView()
                    .environmentObject(appVM)
            }

            if showHelp {
                SwiftUI.Tab("Help", systemImage: "questionmark.circle", value: AppTab.help) {
                    HelpView()
                        .environmentObject(appVM)
                }
            }

            if showTickets {
                SwiftUI.Tab("Tickets", systemImage: "ticket", value: AppTab.tickets) {
                    TicketsView()
                        .environmentObject(appVM)
                }
            }
        }
    }

    // MARK: - iOS 16–17 fallback (custom floating bar)

    private func legacyTabView(primary: Color) -> some View {
        ZStack(alignment: .bottom) {
            // Content
            ZStack {
                if selectedTab == .home {
                    HomeView(
                        onStartConversation: { selectedTab = .messages },
                        onOpenTickets: { selectedTab = .tickets },
                        onOpenHelp: { selectedTab = .help }
                    )
                    .environmentObject(appVM)
                }
                if selectedTab == .messages {
                    MessagesView().environmentObject(appVM)
                }
                if selectedTab == .help && showHelp {
                    HelpView().environmentObject(appVM)
                }
                if selectedTab == .tickets && showTickets {
                    TicketsView().environmentObject(appVM)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()

            // Input bar + tab bar stacked at bottom
            VStack(spacing: 8) {
                if selectedTab == .home {
                    homeInputBar(primary: primary)
                }
                legacyBar(primary: primary)
            }
        }
    }

    private func legacyBar(primary: Color) -> some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases.filter {
                ($0 != .tickets || showTickets) && ($0 != .help || showHelp)
            }) { tab in
                let isActive = selectedTab == tab
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: isActive ? tab.iconFilled : tab.icon)
                            .font(.system(size: 22, weight: isActive ? .semibold : .regular))
                            .foregroundStyle(isActive ? primary : Color(.secondaryLabel))
                        Text(tab.label)
                            .font(.system(size: 10, weight: isActive ? .semibold : .regular))
                            .foregroundStyle(isActive ? primary : Color(.secondaryLabel))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        isActive ? primary.opacity(0.12) : Color.clear,
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 6)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    // MARK: - Home input bar (shared)

    private func homeInputBar(primary: Color) -> some View {
        Group {
            if appVM.requireAuth && !appVM.isIdentified {
                // requireAuth: composing from home isn't possible until the
                // visitor is identified, so the bar just routes to the Messages
                // tab where the inline identity form is shown.
                Button { selectedTab = .messages } label: {
                    HStack(spacing: 12) {
                        Text("How can I help you today?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(primary, in: Circle())
                    }
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 12) {
                    TextField("How can I help you today?", text: $homeText, axis: .vertical)
                        .font(.subheadline)
                        .lineLimit(1...4)
                        .submitLabel(.send)
                        .onSubmit { sendHomeMessage() }

                    Button {
                        if homeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            selectedTab = .messages
                        } else {
                            sendHomeMessage()
                        }
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(
                                homeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? Color.secondary : primary,
                                in: Circle()
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .liquidGlass(
            shape: RoundedRectangle(cornerRadius: 28, style: .continuous),
            shadowRadius: 8
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    private func sendHomeMessage() {
        let text = homeText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        homeText = ""
        appVM.pendingHomeMessage = text
        selectedTab = .messages
    }
}
