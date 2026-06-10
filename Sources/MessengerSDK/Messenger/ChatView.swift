import SwiftUI
import PhotosUI

struct ChatView: View {
    let conversation: Conversation
    /// When set, this message is sent automatically once the chat finishes loading.
    let autoSendMessage: String?

    // @ObservedObject — ChatView observes but does NOT own the ViewModel.
    // Ownership lives in MessagesView's cache so the WS subscription survives
    // sheet dismiss/reopen without reconnecting.
    @ObservedObject var viewModel: ChatViewModel

    @EnvironmentObject var appVM: AppViewModel
    @State private var messageText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker = false
    @FocusState private var inputFocused: Bool
    @Environment(\.dismiss) private var dismiss
    /// Prevents double-firing the auto-send
    @State private var didAutoSend = false

    // Swipe-to-reveal timestamps (Instagram style)
    @State private var swipeOffset: CGFloat = 0
    /// True while a horizontal swipe is in progress — disables vertical scroll
    /// so the two axes don't fight each other.
    @State private var scrollLocked = false
    private let timestampColumnWidth: CGFloat = 72

    init(conversation: Conversation, viewModel: ChatViewModel, autoSendMessage: String? = nil) {
        self.conversation = conversation
        self.viewModel = viewModel
        self.autoSendMessage = autoSendMessage
    }

    private var primary: UIColor { appVM.effectivePrimaryColor }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 4) {
                        if let welcome = appVM.messengerData?.messages?.welcome {
                            WelcomeMessageView(message: welcome, primaryColor: primary)
                                .padding(.top, 8)
                        }
                        ForEach(viewModel.chatRows) { row in
                            chatRow(row)
                        }
                    }
                    .padding(.vertical, 8)
                    // Shift the whole content left to reveal the timestamp column
                    .offset(x: swipeOffset)
                }
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
                // Dragging the conversation up dismisses the keyboard the instant
                // the drag begins — the standard Messages-app behavior.
                .scrollContentBackground(.hidden)
                .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
                .scrollDismissesKeyboard(.immediately)
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
                // New message arrived
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
                // Initial load finished
                .onChange(of: viewModel.isLoading) { loading in
                    if !loading {
                        scrollToBottom(proxy: proxy, animated: false)
                        if !didAutoSend, let text = autoSendMessage {
                            didAutoSend = true
                            viewModel.sendMessage(text, appVM: appVM)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    if !conversation.participatedUsers.isEmpty {
                        agentToolbarTitle
                    } else if viewModel.isBot {
                        botToolbarTitle
                    } else {
                        Text("Conversation")
                            .font(.subheadline.weight(.semibold))
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
    }

    // MARK: - Agent toolbar title (participated user)

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

    // MARK: - Bot toolbar title

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
                isLastInGroup: isLast
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

    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        guard case .message(let id, _, _, _) = viewModel.chatRows.last else { return }
        if animated {
            withAnimation { proxy.scrollTo(id, anchor: .bottom) }
        } else {
            proxy.scrollTo(id, anchor: .bottom)
        }
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
        HStack(alignment: .bottom, spacing: 10) {
            Button { showPhotoPicker = true } label: {
                Image(systemName: "photo")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    // Match the send button size so bottom-alignment is pixel-perfect
                    .frame(width: 34, height: 34)
            }

            TextField("Message…", text: $messageText, axis: .vertical)
                .lineLimit(1...5)
                .focused($inputFocused)
                // No extra vertical padding — the HStack container's .padding(.vertical, 10)
                // provides the spacing. Removing it makes the field the same effective
                // height as the 34pt buttons on a single line, so bottom-alignment
                // visually centers everything for single-line and still pins the send
                // button to the bottom when the field grows to multiple lines.
                .frame(minHeight: 34, alignment: .center)

            Button {
                let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !text.isEmpty else { return }
                messageText = ""
                viewModel.sendMessage(text, appVM: appVM)
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(
                        messageText.isEmpty ? Color.secondary : primary,
                        in: Circle()
                    )
            }
            .disabled(messageText.isEmpty && viewModel.pendingAttachments.isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .liquidGlass(
            shape: RoundedRectangle(cornerRadius: 28, style: .continuous),
            shadowRadius: 8
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 20)
    }
}
