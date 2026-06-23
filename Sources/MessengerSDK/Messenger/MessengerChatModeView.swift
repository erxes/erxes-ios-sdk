import SwiftUI

/// ChatGPT/Claude-style messenger shell (`displayMode == .chat`).
///
/// - Home (no active conversation) is a "new chat" screen: greeting + input bar.
/// - A top-left drawer button — or a left-edge swipe — opens a full-screen drawer
///   holding host-configured action rows, a "New chat" button, and the conversation
///   list. Selecting a conversation shows it inline, full-screen.
/// - The whole experience is presented full-screen, so the top bar carries an
///   explicit close (`xmark`) control.
///
/// Reuses `ChatContentView` (message list + input), `ConversationListViewModel`,
/// `ConversationRowView`, and `ChatViewModel` — mirroring `MessagesView`'s VM
/// ownership so WebSocket subscriptions survive view churn.
struct MessengerChatModeView: View {
    @ObservedObject var appVM: AppViewModel
    /// Whether to show the top-right close button. Only meaningful when there's
    /// somewhere to return to — i.e. the floating launcher was visible when the
    /// messenger opened. In chat mode the launcher is hidden, so there's no close.
    var showsCloseButton: Bool = false
    /// Drives the loading indicator: the shell fades in once the connect handshake
    /// finishes (`isReady`).
    @ObservedObject private var sdk = MessengerSDK.shared
    @Environment(\.dismiss) private var dismiss

    @StateObject private var listVM = ConversationListViewModel()

    // ── Active chat ───────────────────────────────────────────────────────────
    // nil conversation = new-chat home. The VM is owned here (cached) so its WS
    // subscription survives switching between conversations.
    @State private var activeConversation: Conversation?
    @State private var activeVM: ChatViewModel?
    @State private var activeAutoSend: String?
    /// Set when the draft conversation was started by tapping "+" on the home
    /// composer (rather than by sending text) — tells `ChatContentView` to open
    /// the photo picker as soon as it appears.
    @State private var activeAutoOpenPhotoPicker = false
    @State private var chatVMCache: [String: ChatViewModel] = [:]

    // ── New-chat home input ─────────────────────────────────────────────────────
    @State private var homeText = ""
    @FocusState private var homeFocused: Bool

    // ── Drawer ──────────────────────────────────────────────────────────────────
    @State private var drawerOpen = false
    @State private var dragTranslation: CGFloat = 0

    private var primary: Color { Color(appVM.effectivePrimaryColor) }

    var body: some View {
        ZStack {
            // Connected content fades in; a loading indicator shows until ready.
            shell
                .opacity(sdk.isReady ? 1 : 0)

            if !sdk.isReady {
                loadingView
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: sdk.isReady)
        .environment(\.colorScheme, appVM.effectiveColorScheme)
        .tint(primary)
        .environmentObject(appVM)
        // Load conversations only once connected — the fetch keys off the
        // customerId/visitorId established during the connect handshake. Firing
        // on bare `onAppear` runs before connect resolves, so it fetches with no
        // identity, gets an empty list, and never refetches (the "Recent empty
        // on first render" bug). Load now if already connected (a re-present of
        // the cached chat VC), otherwise wait for the handshake to flip ready.
        .onAppear { if sdk.isReady { listVM.load(appVM: appVM) } }
        .onChange(of: sdk.isReady) { ready in
            if ready { listVM.load(appVM: appVM) }
        }
    }

    /// Centered spinner shown over the container background while connecting.
    private var loadingView: some View {
        ZStack {
            Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea()
            ProgressView()
                .controlSize(.large)
                .tint(primary)
        }
    }

    private var shell: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let offset = drawerOffset(width: width)

            ZStack(alignment: .leading) {
                // ── Main column ─────────────────────────────────────────────────
                VStack(spacing: 0) {
                    topBar
                    Divider().opacity(0.4)
                    mainContent
                }
                .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())

                // Left-edge strip to open the drawer by swiping in. Kept thin so it
                // doesn't fight ChatContentView's own horizontal swipe gesture.
                if !drawerOpen {
                    Color.clear
                        .frame(width: 24)
                        .frame(maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .gesture(edgeOpenGesture(width: width))
                }

                // ── Dimming scrim ────────────────────────────────────────────────
                Color.black
                    .opacity(scrimOpacity(offset: offset, width: width))
                    .ignoresSafeArea()
                    .allowsHitTesting(drawerOpen)
                    .onTapGesture { setDrawer(false) }

                // ── Drawer panel ─────────────────────────────────────────────────
                drawerPanel
                    .frame(width: width)
                    .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
                    .offset(x: offset)
                    .gesture(drawerCloseGesture(width: width))
            }
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        // A ZStack centers the title on the bar itself rather than in the
        // leftover space between the leading/trailing buttons — those two
        // sides have unequal widths (trailing grows with header actions), so
        // an HStack-with-spacers layout would push the title off-center.
        ZStack {
            Group {
                if let conv = activeConversation, let vm = activeVM {
                    ChatTitleView(conversation: conv, viewModel: vm)
                        .environmentObject(appVM)
                } else {
                    Text("New chat")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
            }
            .frame(maxWidth: .infinity)

            HStack(spacing: 12) {
                Button { setDrawer(true) } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 38, height: 38)
                        .liquidGlass(shape: Circle())
                }

                Spacer(minLength: 8)

                HStack(spacing: 6) {
                    // Host-configured home actions appear only on the new-chat home —
                    // a conversation keeps a clean top bar so its title/controls stay
                    // uncluttered. New chat lives in the drawer's floating button.
                    if activeConversation == nil {
                        ForEach(homeActions) { item in
                            Button { MessengerSDK.shared.onAction?(item.id) } label: {
                                Image(systemName: item.systemIcon)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.primary)
                                    .frame(width: 38, height: 38)
                                    .liquidGlass(shape: Circle())
                            }
                            .accessibilityLabel(item.title)
                        }
                    }

                    // Close the full-screen messenger — only when there's a launcher
                    // to return to (hidden in launcher-less chat mode).
                    if showsCloseButton {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                                .frame(width: 32, height: 36)
                        }
                        .accessibilityLabel("Close")
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    // MARK: - Main content (home vs. active chat)

    @ViewBuilder
    private var mainContent: some View {
        if let conv = activeConversation, let vm = activeVM {
            ChatContentView(
                conversation: conv,
                viewModel: vm,
                autoSendMessage: activeAutoSend,
                autoOpenPhotoPicker: activeAutoOpenPhotoPicker
            )
                .environmentObject(appVM)
                // Re-identify by conversation id so switching chats rebuilds state.
                .id(vm.conversationId.isEmpty ? "new" : vm.conversationId)
        } else {
            newChatHome
        }
    }

    private var newChatHome: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 14) {
                Image(systemName: "sparkles")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(primary)

                Text(appVM.messengerData?.messages?.greetTitle ?? "How can I help?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)

                if let greet = appVM.messengerData?.messages?.greet, !greet.isEmpty {
                    Text(greet)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) { homeInputBar }
        .dismissKeyboardOnVerticalDrag()
        .dismissKeyboardOnTap()
    }

    private var homeInputBar: some View {
        // Shared composer: same mic / dictation / attachment controls as the
        // in-conversation bar. Sending or attaching starts a new conversation.
        MessageComposerBar(
            text: $homeText,
            placeholder: "Ask anything…",
            primary: primary,
            focused: $homeFocused,
            showsAttachment: true,
            onPlus: { startNewChatForAttachment() },
            onSend: { beginSend(text: homeText) }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Drawer

    /// Header height the scrolling list reserves space for underneath the sticky bar.
    private let drawerHeaderHeight: CGFloat = 80

    private var drawerPanel: some View {
        ZStack(alignment: .top) {
            // Conversation list scrolls underneath the sticky header below.
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    Color.clear.frame(height: drawerHeaderHeight)

                    // Host-configured drawer action rows (like ChatGPT's Projects/Images)
                    ForEach(drawerActions) { item in
                        drawerRow(icon: item.systemIcon, title: item.title) {
                            MessengerSDK.shared.onAction?(item.id)
                            setDrawer(false)
                        }
                    }

                    if !drawerActions.isEmpty && !listVM.conversations.isEmpty {
                        Divider().padding(.horizontal, 16).padding(.vertical, 8)
                    }

                    // Conversation list
                    if listVM.isLoading {
                        ProgressView().padding(.top, 24).frame(maxWidth: .infinity)
                    } else if listVM.conversations.isEmpty {
                        Text("No conversations yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    } else {
                        Text("RECENTS")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 2)
                        ForEach(listVM.conversations) { conv in
                            Button { openConversation(conv) } label: {
                                ConversationRowView(conversation: conv)
                                    .environmentObject(appVM)
                            }
                            .buttonStyle(.plain)
                            .background(
                                activeConversation?.id == conv.id
                                    ? primary.opacity(0.12) : Color.clear
                            )
                        }
                    }
                }
                // Leave room so the floating button doesn't cover the last row.
                .padding(.bottom, 96)
            }

            // Sticky header — solid, opaque, same surface as the drawer (not a
            // blurred material) with a long soft fade below so scrolling rows
            // dissolve into it the way ChatGPT's sidebar title bar does.
            VStack(spacing: 0) {
                HStack {
                    Text("Chats")
                        .font(.largeTitle.weight(.bold))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(appVM.effectiveContainerBackgroundColor))

                LinearGradient(
                    stops: [
                        .init(color: Color(appVM.effectiveContainerBackgroundColor), location: 0),
                        .init(color: Color(appVM.effectiveContainerBackgroundColor).opacity(0.8), location: 0.4),
                        .init(color: Color(appVM.effectiveContainerBackgroundColor).opacity(0), location: 1)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 28)
                .allowsHitTesting(false)
            }
        }
        .padding(.top, 8)
        // Floating "New chat" button, bottom-right — like ChatGPT's compose pill.
        .overlay(alignment: .bottomTrailing) { newChatButton }
    }

    /// White-on-dark (inverted) pill that starts a fresh conversation.
    private var newChatButton: some View {
        Button { startNewChat() } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16, weight: .semibold))
                Text("New chat")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(Color(appVM.effectiveContainerBackgroundColor))
            .padding(.horizontal, 18)
            .padding(.vertical, 13)
            .background(Color.primary, in: Capsule())
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 28)
    }

    private func drawerRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 28)
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions

    private var homeActions: [ActionItem] { appVM.config?.homeActions ?? [] }
    private var drawerActions: [ActionItem] { appVM.config?.drawerActions ?? [] }

    /// Starts a brand-new conversation (returns to the home composer, optionally
    /// auto-sending `autoSend`).
    private func startNewChat(autoSend: String? = nil) {
        graduateActiveVM()
        setDrawer(false)
        activeAutoOpenPhotoPicker = false
        if let text = autoSend, !text.isEmpty {
            let vm = ChatViewModel(conversationId: "")
            activeVM = vm
            activeConversation = Conversation(id: "", content: nil, createdAt: Date())
            activeAutoSend = text
        } else {
            activeVM = nil
            activeConversation = nil
            activeAutoSend = nil
        }
    }

    /// Tapping "+" on the new-chat home composer, before any text was sent.
    /// Starts a draft conversation (mirroring `startNewChat(autoSend:)`) so the
    /// shared `ChatContentView` — and its attachment strip — takes over, then
    /// opens the photo picker as soon as it appears.
    private func startNewChatForAttachment() {
        graduateActiveVM()
        setDrawer(false)
        let vm = ChatViewModel(conversationId: "")
        activeVM = vm
        activeConversation = Conversation(id: "", content: nil, createdAt: Date())
        activeAutoSend = nil
        activeAutoOpenPhotoPicker = true
    }

    private func openConversation(_ conv: Conversation) {
        graduateActiveVM()
        let vm = chatVMCache[conv.id] ?? ChatViewModel(conversationId: conv.id)
        chatVMCache[conv.id] = vm
        activeVM = vm
        activeConversation = conv
        activeAutoSend = nil
        activeAutoOpenPhotoPicker = false
        setDrawer(false)
    }

    /// Caches the active VM once it has a real conversation id, and refreshes the
    /// list so a just-created conversation shows up in the drawer.
    private func graduateActiveVM() {
        if let vm = activeVM, !vm.conversationId.isEmpty {
            chatVMCache[vm.conversationId] = vm
            listVM.load(appVM: appVM)
        }
    }

    /// Home composer send.
    private func beginSend(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        homeText = ""
        startNewChat(autoSend: trimmed)
    }

    // MARK: - Drawer geometry

    private func setDrawer(_ open: Bool) {
        dismissKeyboard()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            drawerOpen = open
            dragTranslation = 0
        }
    }

    private func drawerOffset(width: CGFloat) -> CGFloat {
        let base = drawerOpen ? CGFloat(0) : -width
        return min(0, max(-width, base + dragTranslation))
    }

    private func scrimOpacity(offset: CGFloat, width: CGFloat) -> Double {
        guard width > 0 else { return 0 }
        return Double((offset + width) / width) * 0.4
    }

    private func edgeOpenGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                // Only track rightward drags from the edge.
                dragTranslation = max(0, value.translation.width)
            }
            .onEnded { value in
                let projected = value.translation.width + value.predictedEndTranslation.width * 0.25
                // Reset the drag offset in the same animation as the open/close
                // commit so the drawer continues smoothly from where the finger
                // left it, instead of @GestureState snapping it back to 0 first.
                setDrawer(projected > width * 0.25)
            }
    }

    private func drawerCloseGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                // Only track leftward drags while open.
                dragTranslation = min(0, value.translation.width)
            }
            .onEnded { value in
                let projected = value.translation.width + value.predictedEndTranslation.width * 0.25
                setDrawer(projected > -width * 0.25)
            }
    }
}
