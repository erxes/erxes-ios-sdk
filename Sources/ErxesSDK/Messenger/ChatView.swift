import SwiftUI
import PhotosUI

struct ChatView: View {
    let conversation: Conversation
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel: ChatViewModel
    @State private var messageText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @FocusState private var inputFocused: Bool

    init(conversation: Conversation) {
        self.conversation = conversation
        _viewModel = StateObject(wrappedValue: ChatViewModel(conversationId: conversation.id))
    }

    var body: some View {
        let primary = appVM.effectivePrimaryColor
        ZStack(alignment: .bottom) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 4) {
                        if let welcome = appVM.messengerData?.messages?.welcome {
                            WelcomeMessageView(message: welcome, primaryColor: primary)
                                .padding(.top, 8)
                        }
                        ForEach(viewModel.chatRows) { row in
                            switch row {
                            case .dateSeparator(_, let label):
                                DateSeparatorView(label: label)
                            case .message(_, let msg, let isFirst, let isLast):
                                MessageBubble(
                                    message: msg,
                                    primaryColor: primary,
                                    isFirstInGroup: isFirst,
                                    isLastInGroup: isLast
                                )
                                .id(msg.id)
                            }
                        }
                        // Space for input bar
                        Spacer().frame(height: 80)
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: viewModel.chatRows.count) { _ in
                    if case .message(let id, _, _, _) = viewModel.chatRows.last {
                        withAnimation { proxy.scrollTo(id, anchor: .bottom) }
                    }
                }
            }

            // Overlays
            VStack(spacing: 0) {
                if viewModel.isBotTyping { TypingStatusView() }
                if !viewModel.persistentMenu.isEmpty {
                    PersistentMenuView(items: viewModel.persistentMenu) {
                        viewModel.sendMessage($0)
                    }
                }
                inputBar(primary: Color(primary))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.load(appVM: appVM) }
    }

    // MARK: - Glass input bar

    private func inputBar(primary: Color) -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Image(systemName: "photo")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 34, height: 34)
            }
            .onChange(of: selectedPhoto) { _ in
                Task { await viewModel.attachPhoto(selectedPhoto, appVM: appVM) }
            }

            TextField("Message…", text: $messageText, axis: .vertical)
                .lineLimit(1...5)
                .focused($inputFocused)
                .padding(.vertical, 8)

            Button {
                let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !text.isEmpty else { return }
                messageText = ""
                viewModel.sendMessage(text)
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
