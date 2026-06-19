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
    @State private var chatVMCache: [String: ChatViewModel] = [:]

    // ── New-chat home input ─────────────────────────────────────────────────────
    @State private var homeText = ""
    @FocusState private var homeFocused: Bool

    // ── requireAuth ───────────────────────────────────────────────────────────
    @State private var showAuth = false
    @State private var pendingAutoSendAfterAuth: String?

    // ── Drawer ──────────────────────────────────────────────────────────────────
    @State private var drawerOpen = false
    @GestureState private var dragTranslation: CGFloat = 0

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
        .onAppear { listVM.load(appVM: appVM) }
        .sheet(isPresented: $showAuth, onDismiss: {
            // GetNotifiedView flips appVM.isIdentified on success; only then proceed.
            guard appVM.isIdentified, let text = pendingAutoSendAfterAuth else { return }
            pendingAutoSendAfterAuth = nil
            startNewChat(autoSend: text)
        }) {
            GetNotifiedView {
                showAuth = false   // success → onDismiss opens the chat
            }
            .environmentObject(appVM)
            .presentationDetents([.medium, .large])
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
        HStack(spacing: 12) {
            Button { setDrawer(true) } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
            }

            Spacer(minLength: 8)

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

            Spacer(minLength: 8)

            HStack(spacing: 6) {
                // Host-configured header-right actions appear only inside a
                // conversation — the new-chat home keeps a clean top bar (the
                // ChatGPT layout). New chat lives in the drawer's floating button.
                if activeConversation != nil {
                    ForEach(headerActions) { item in
                        Button { MessengerSDK.shared.onAction?(item.id) } label: {
                            Image(systemName: item.systemIcon)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 32, height: 36)
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
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    // MARK: - Main content (home vs. active chat)

    @ViewBuilder
    private var mainContent: some View {
        if let conv = activeConversation, let vm = activeVM {
            ChatContentView(conversation: conv, viewModel: vm, autoSendMessage: activeAutoSend)
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

    @ViewBuilder
    private var homeInputBar: some View {
        Group {
            if appVM.requireAuth && !appVM.isIdentified {
                // Composing isn't possible until identified — tapping starts the
                // identity capture flow.
                Button { beginSend(text: "") } label: {
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
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .liquidGlass(
                    shape: RoundedRectangle(cornerRadius: 28, style: .continuous),
                    shadowRadius: 8
                )
            } else {
                // Shared composer: same mic / dictation controls as the
                // in-conversation bar. Sending starts a new conversation.
                MessageComposerBar(
                    text: $homeText,
                    placeholder: "Ask anything…",
                    primary: primary,
                    focused: $homeFocused,
                    showsAttachment: false,
                    onSend: { beginSend(text: homeText) }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Drawer

    private var drawerPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Chats")
                    .font(.title2.weight(.bold))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
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

    private var headerActions: [ActionItem] { appVM.config?.homeActions ?? [] }
    private var drawerActions: [ActionItem] { appVM.config?.drawerActions ?? [] }

    /// Starts a brand-new conversation (returns to the home composer, optionally
    /// auto-sending `autoSend`).
    private func startNewChat(autoSend: String? = nil) {
        graduateActiveVM()
        setDrawer(false)
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

    private func openConversation(_ conv: Conversation) {
        graduateActiveVM()
        let vm = chatVMCache[conv.id] ?? ChatViewModel(conversationId: conv.id)
        chatVMCache[conv.id] = vm
        activeVM = vm
        activeConversation = conv
        activeAutoSend = nil
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

    /// Home composer send. Gated behind the identity form when requireAuth is on.
    private func beginSend(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if appVM.requireAuth && !appVM.isIdentified {
            pendingAutoSendAfterAuth = trimmed
            showAuth = true
            return
        }
        guard !trimmed.isEmpty else { return }
        homeText = ""
        startNewChat(autoSend: trimmed)
    }

    // MARK: - Drawer geometry

    private func setDrawer(_ open: Bool) {
        dismissKeyboard()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            drawerOpen = open
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
            .updating($dragTranslation) { value, state, _ in
                // Only track rightward drags from the edge.
                state = max(0, value.translation.width)
            }
            .onEnded { value in
                let projected = value.translation.width + value.predictedEndTranslation.width * 0.25
                setDrawer(projected > width * 0.25)
            }
    }

    private func drawerCloseGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($dragTranslation) { value, state, _ in
                // Only track leftward drags while open.
                state = min(0, value.translation.width)
            }
            .onEnded { value in
                let projected = value.translation.width + value.predictedEndTranslation.width * 0.25
                setDrawer(projected > -width * 0.25)
            }
    }
}
