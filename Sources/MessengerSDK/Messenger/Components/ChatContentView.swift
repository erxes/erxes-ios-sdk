import SwiftUI
import PhotosUI

/// The scrollable message list + input bar core of a chat, with no surrounding
/// navigation chrome. Shared by:
/// - `ChatView` — the classic sheet, which wraps this in a `NavigationStack` and
///   supplies its own toolbar (dismiss button + title).
/// - `MessengerChatModeView` — chat mode, which renders this under a custom top bar.
///
/// Owns the input/photo/swipe state. The `ChatViewModel` is observed but owned
/// elsewhere so its WebSocket subscription survives view teardown.
struct ChatContentView: View {
    let conversation: Conversation
    /// When set, this message is sent automatically once the chat finishes loading.
    let autoSendMessage: String?
    /// When true, the photo picker opens automatically once the chat finishes
    /// loading — used when the user tapped "+" before any conversation existed
    /// (the new-chat home composer).
    let autoOpenPhotoPicker: Bool
    /// Extra space reserved at the top of the message list so the first rows
    /// aren't hidden behind a floating header. Chat mode (`MessengerChatModeView`)
    /// renders this view under a custom glass top bar that overlays the content,
    /// so it passes the bar's height here; the classic sheet (`ChatView`) uses a
    /// real navigation toolbar that already provides safe-area, so it leaves this 0.
    let topContentInset: CGFloat

    @ObservedObject var viewModel: ChatViewModel
    @EnvironmentObject var appVM: AppViewModel

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker = false
    @FocusState private var inputFocused: Bool
    /// Prevents double-firing the auto-send
    @State private var didAutoSend = false
    /// Prevents double-firing the auto-opened photo picker
    @State private var didAutoOpenPhotoPicker = false


    // Swipe-to-reveal timestamps (Instagram style)
    @State private var swipeOffset: CGFloat = 0
    /// True while a horizontal swipe is in progress — disables vertical scroll
    /// so the two axes don't fight each other.
    @State private var scrollLocked = false
    private let timestampColumnWidth: CGFloat = 72

    /// Tracks whether the bottom marker is currently visible, i.e. the user
    /// is scrolled to (or near) the end of the chat. Drives the floating
    /// "scroll to bottom" button.
    @State private var isAtBottom = true
    private let bottomMarkerID = "ChatContentView.bottomMarker"

    /// The whole conversation is rendered at once (no windowing), and we open at
    /// the bottom. The list is kept hidden until that first scroll-to-bottom has
    /// settled, then faded in — so the brief layout settling of long messages
    /// isn't visible as a jump.
    @State private var revealed = false

    init(
        conversation: Conversation,
        viewModel: ChatViewModel,
        autoSendMessage: String? = nil,
        autoOpenPhotoPicker: Bool = false,
        topContentInset: CGFloat = 0
    ) {
        self.conversation = conversation
        self.viewModel = viewModel
        self.autoSendMessage = autoSendMessage
        self.autoOpenPhotoPicker = autoOpenPhotoPicker
        self.topContentInset = topContentInset
    }

    private var primary: UIColor { appVM.effectivePrimaryColor }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 4) {
                    // Clears a floating header (chat mode). Scrolls with the
                    // content so messages still slide under the glass bar, but
                    // keeps the topmost rows fully visible when scrolled up.
                    if topContentInset > 0 {
                        Color.clear.frame(height: topContentInset)
                    }
                    if let welcome = appVM.messengerData?.messages?.welcome {
                        WelcomeMessageView(message: welcome, primaryColor: primary)
                            .padding(.top, 8)
                    }
                    ForEach(viewModel.chatRows) { row in
                        chatRow(row)
                    }
                    // Invisible sentinel — its visibility tells us whether the
                    // user is scrolled to the end of the chat.
                    Color.clear
                        .frame(height: 1)
                        .id(bottomMarkerID)
                        .onAppear { isAtBottom = true }
                        .onDisappear { isAtBottom = false }
                }
                .padding(.vertical, 8)
                // Shift the whole content left to reveal the timestamp column
                .offset(x: swipeOffset)
            }
            // Hidden until the initial open-at-bottom scroll has settled, so the
            // brief layout settling of long messages isn't seen as a jump.
            .opacity(revealed ? 1 : 0)
            // Lock vertical scroll while a horizontal swipe is active so the
            // two axes don't fight. scrollDisabled is flipped once direction
            // is determined and reset when the gesture ends.
            .scrollDisabled(scrollLocked)
            .simultaneousGesture(
                DragGesture(minimumDistance: 5)
                    .onChanged { value in
                        let h = abs(value.translation.width)
                        let v = abs(value.translation.height)

                        if !scrollLocked {
                            // Wait until movement is clear enough to call direction
                            guard h > 8 || v > 8 else { return }
                            // If vertical wins → let scroll view handle it, bail out
                            guard h > v else { return }
                            // Horizontal confirmed — lock vertical scroll for this drag
                            scrollLocked = true
                        }

                        // Only track leftward swipes (negative offset)
                        swipeOffset = min(0, max(-timestampColumnWidth, value.translation.width))
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            swipeOffset = 0
                        }
                        scrollLocked = false
                    }
            )
            .scrollContentBackground(.hidden)
            .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
            // Dragging down past the keyboard's height dismisses it interactively
            // (ChatGPT/Messages-style, follows the gesture 1:1) — plus an explicit
            // tap on the chat background as a fallback. simultaneousGesture so the
            // tap doesn't steal touches from scrolling or message long-press/copy.
            .scrollDismissesKeyboard(.interactively)
            .simultaneousGesture(TapGesture().onEnded { inputFocused = false })
            .overlay(alignment: .bottom) { scrollToBottomButton(proxy: proxy) }
            .overlay(alignment: .top) {
                // Chat mode (topContentInset > 0) floats a glass top bar
                // above this view in an outer ZStack — rendering the toast
                // here would draw it underneath that bar. Chat mode renders
                // its own copy of this toast above the bar instead; see
                // `MessengerChatModeView.copiedToastOverlay`.
                if topContentInset == 0, viewModel.showCopiedToast {
                    CopiedToastView()
                        .padding(.top, 8)
                        // Grows out from the top edge rather than sliding
                        // down — matches how system Dynamic Island alerts
                        // (e.g. Now Playing) animate in.
                        .transition(CopiedToastView.transition)
                        .zIndex(1)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.showCopiedToast)
            // The input bar lives in a bottom safe-area inset. SwiftUI's native
            // keyboard avoidance lifts this inset above the keyboard inside the
            // SAME animation transaction as the keyboard itself, so the bar and
            // keyboard move in perfect sync — no custom observer, no desync, no lag.
            .safeAreaInset(edge: .bottom, spacing: 0) {
                inputBarArea
            }
            // Keyboard appeared — push the last message above the input bar.
            // Defer one run-loop so the safeAreaInset has already grown before
            // we scroll; otherwise the proxy measures the old inset.
            .onChange(of: inputFocused) { focused in
                guard focused else { return }
                DispatchQueue.main.async {
                    scrollToBottom(proxy: proxy)
                }
            }
            // New message arrived — keep the latest message in view.
            .onChange(of: viewModel.chatRows.count) { _ in
                scrollToBottom(proxy: proxy)
            }
            // Attachment strip appeared or disappeared — the safeAreaInset
            // height changed, so the last message may now be behind the bar.
            // Defer so the inset has updated before we scroll.
            .onChange(of: viewModel.pendingAttachments.count) { _ in
                DispatchQueue.main.async {
                    scrollToBottom(proxy: proxy)
                }
            }
            // Initial load finished — jump to the bottom, then reveal.
            .onChange(of: viewModel.isLoading) { loading in
                if !loading {
                    scrollToBottom(proxy: proxy, animated: false)
                    revealAfterSettle()
                    if !didAutoSend, let text = autoSendMessage {
                        didAutoSend = true
                        viewModel.sendMessage(text, appVM: appVM)
                    }
                    if !didAutoOpenPhotoPicker && autoOpenPhotoPicker {
                        didAutoOpenPhotoPicker = true
                        showPhotoPicker = true
                    }
                }
            }
            // The view model may already be loaded when this view appears — in
            // chat mode VMs are cached so their WebSocket survives, so re-opening
            // (or switching back to) a conversation reuses a VM whose `isLoading`
            // is already false. The onChange above never fires in that case, so
            // scroll to the bottom (and reveal) explicitly for the loaded path.
            .onAppear {
                if viewModel.isLoaded {
                    if !viewModel.chatRows.isEmpty {
                        scrollToBottom(proxy: proxy, animated: false)
                    }
                    revealAfterSettle()
                }
            }
        }
        .onAppear { viewModel.load(appVM: appVM) }
        // Present at top level so PHPickerViewController has a proper
        // presentation context — embedding PhotosPicker deep inside a
        // safeAreaInset causes it to silently fail on some iOS versions.
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhoto) { item in
            guard let item else { return }
            Task { await viewModel.attachPhoto(item, appVM: appVM) }
            selectedPhoto = nil   // reset so the same photo can be re-picked
        }
    }

    // MARK: - Chat rows

    @ViewBuilder
    private func chatRow(_ row: ChatRow) -> some View {
        switch row {
        case .dateSeparator(_, let label):
            DateSeparatorView(label: label)

        case .message(_, let msg, let isFirst, let isLast):
            // Bubble gets the FULL screen width — the timestamp does NOT share
            // the HStack layout chain (which would shrink the bubble by 72pt and
            // leave an empty gap on the right side for customer messages).
            // Instead the timestamp is an overlay pushed exactly `timestampColumnWidth`
            // pts beyond the bubble's trailing edge. Normally the ScrollView clips it.
            // When the LazyVStack offsets left the timestamp slides into view.
            MessageBubble(
                message: msg,
                primaryColor: primary,
                isFirstInGroup: isFirst,
                isLastInGroup: isLast,
                onCopy: { viewModel.presentCopiedToast() }
            )
            .environmentObject(appVM)
            .id(msg.id)
            .overlay(alignment: .trailing) {
                timestampLabel(for: msg)
            }
        }
    }

    private func timestampLabel(for msg: Message) -> some View {
        Text(shortTime(msg.createdAt))
            .font(Font.caption2)
            .foregroundStyle(Color.secondary)
            .lineLimit(1)
            .frame(width: timestampColumnWidth, alignment: .center)
            // Push it just past the right edge; the ScrollView clips it.
            // Slides into view as swipeOffset goes negative.
            .offset(x: timestampColumnWidth)
            .opacity(Double(min(1, abs(swipeOffset) / 30)))
    }

    // MARK: - Timestamp

    private static let timeFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    private func shortTime(_ date: Date) -> String {
        Self.timeFmt.string(from: date)
    }

    // MARK: - Scroll helpers

    /// Fades the list in once the open-at-bottom scroll has settled. The list is
    /// rendered hidden so the brief layout settling of long messages (and the
    /// scroll passes that chase it) happens off-screen rather than as a visible
    /// jump. Idempotent — only the first call schedules the reveal.
    private func revealAfterSettle() {
        guard !revealed else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.easeOut(duration: 0.15)) { revealed = true }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        // A single scrollTo can land short of the real bottom: if the list is
        // still decelerating from a flick, the ScrollView swallows the
        // programmatic scroll; and because the bottom marker lives in a
        // LazyVStack, rows below the viewport may only get realized *during*
        // the scroll, changing the total height after the target was computed.
        // Issuing the scroll again on the next run loop overrides any in-flight
        // deceleration and re-targets the now-correct bottom.
        let jump = { proxy.scrollTo(bottomMarkerID, anchor: .bottom) }
        if animated {
            withAnimation { jump() }
            DispatchQueue.main.async { withAnimation { jump() } }
            return
        }
        // The non-animated path runs on first open / chat switch. Two things make
        // a single jump land short:
        //  • the bottom marker lives in a LazyVStack, so rows below the viewport
        //    are realized only *during* the scroll, growing the total height; and
        //  • a long last message reports its final (much taller) text height a few
        //    frames after its row first appears, so an immediate jump computes the
        //    bottom against an underestimated height and stops mid-message.
        // Re-issue the jump on a spread-out schedule so a later pass re-targets the
        // now-correct bottom once layout has settled.
        jump()
        for delay in [0.016, 0.05, 0.1, 0.2, 0.35, 0.5] {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: jump)
        }
    }

    /// Floating button shown once the user has scrolled away from the latest
    /// message, mirroring the "jump to bottom" affordance in apps like ChatGPT.
    private func scrollToBottomButton(proxy: ScrollViewProxy) -> some View {
        Button {
            scrollToBottom(proxy: proxy)
        } label: {
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(Color.black.opacity(0.6), in: Circle())
        }
        .padding(.bottom, 8)
        .opacity(isAtBottom ? 0 : 1)
        .scaleEffect(isAtBottom ? 0.8 : 1)
        .animation(.easeInOut(duration: 0.2), value: isAtBottom)
        .allowsHitTesting(!isAtBottom)
    }

    // MARK: - Input bar

    private var inputBarArea: some View {
        VStack(spacing: 0) {
            if viewModel.isBotTyping { TypingStatusView() }
            if !viewModel.persistentMenu.isEmpty {
                PersistentMenuView(items: viewModel.persistentMenu) {
                    viewModel.sendMessage($0, appVM: appVM)
                }
            }
            // Pending attachment thumbnails
            if !viewModel.pendingAttachments.isEmpty {
                pendingAttachmentsStrip
            }
            inputBar(primary: Color(primary))
        }
    }

    private var pendingAttachmentsStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.pendingAttachments) { pending in
                    ZStack(alignment: .topTrailing) {

                        // ── Thumbnail ──────────────────────────────────────────
                        Group {
                            if let thumb = pending.thumbnail {
                                Image(uiImage: thumb)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Color(.systemGray5)
                            }
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                        // Upload in-progress: dim the thumbnail and show a spinner
                        .overlay {
                            if pending.isUploading {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.black.opacity(0.45))
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(0.9)
                            }
                        }

                        // ── Remove button (hidden while uploading) ─────────────
                        if !pending.isUploading {
                            Button {
                                viewModel.pendingAttachments.removeAll { $0.id == pending.id }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                                    .background(Color.black.opacity(0.55), in: Circle())
                            }
                            .offset(x: 5, y: -5)
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 10)
            .padding(.bottom, 4)
        }
    }

    private func inputBar(primary: Color) -> some View {
        MessageComposerBar(
            text: $viewModel.draftText,
            placeholder: "Message…",
            primary: primary,
            hasAttachments: !viewModel.pendingAttachments.isEmpty,
            focused: $inputFocused,
            showsAttachment: true,
            onPlus: { showPhotoPicker = true },
            onSend: {
                let text = viewModel.draftText.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.draftText = ""
                viewModel.sendMessage(text, appVM: appVM)
            }
        )
        .padding(.horizontal, 12)
        .padding(.bottom, inputFocused ? 8 : 4)
    }
}

// MARK: - Copied toast

/// Mimics a Dynamic Island alert — there's no public API for a native
/// "Copied" pill on writes (only the system shows one automatically on
/// paste), so we replicate the look: a black capsule that sits right at the
/// island and grows out of it, rather than a generic toast sliding in from
/// the top edge.
struct CopiedToastView: View {
    /// Distinct open vs. close: grows out of the island on appear, then snaps
    /// back up faster on dismiss so it doesn't linger. Reused by every render
    /// site (ChatContentView overlay + chat mode's `CopiedToastHost`).
    static let transition: AnyTransition = .asymmetric(
        insertion: .scale(scale: 0.4, anchor: .top).combined(with: .opacity),
        removal: .scale(scale: 0.6, anchor: .top).combined(with: .opacity)
    )

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
            Text("Copied")
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black, in: Capsule())
        .shadow(color: .black.opacity(0.3), radius: 8, y: 3)
    }
}

// MARK: - Chat title (agent / bot / fallback)

/// The conversation title shown in chat chrome. Used by `ChatView`'s toolbar
/// principal item and by `MessengerChatModeView`'s custom top bar.
struct ChatTitleView: View {
    @EnvironmentObject var appVM: AppViewModel
    let conversation: Conversation
    @ObservedObject var viewModel: ChatViewModel

    private var primary: UIColor { appVM.effectivePrimaryColor }

    var body: some View {
        if !conversation.participatedUsers.isEmpty {
            agentToolbarTitle
        } else if viewModel.isBot {
            botToolbarTitle
        } else {
            Text("Conversation")
                .font(.subheadline.weight(.semibold))
        }
    }

    // MARK: - Agent title (participated user)

    private var agentToolbarTitle: some View {
        let user = conversation.participatedUsers[0]
        return HStack(spacing: 10) {
            AvatarWithStatusView(
                avatarKey: user.details?.avatar,
                isOnline: user.isOnline,
                size: 34
            )
            .environmentObject(appVM)

            VStack(alignment: .leading, spacing: 1) {
                Text(user.details?.displayName ?? "Support")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(user.isOnline ? "Online" : "Offline")
                    .font(.caption2)
                    .foregroundStyle(user.isOnline ? .green : .secondary)
            }
        }
    }

    // MARK: - Bot title

    private var botToolbarTitle: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.48, green: 0.25, blue: 0.90),
                                 Color(red: 0.28, green: 0.10, blue: 0.70)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 34, height: 34)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 5) {
                    Text("AI agent")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text("AI")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color(primary), in: Capsule())
                }

                Text("Automated · replies instantly")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
