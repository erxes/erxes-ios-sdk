import SwiftUI
import PhotosUI

struct ChatView: View {
    let conversation: Conversation
    let config: ErxesConfig

    @StateObject private var viewModel: ChatViewModel
    @State private var messageText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @FocusState private var inputFocused: Bool

    init(conversation: Conversation, config: ErxesConfig) {
        self.conversation = conversation
        self.config = config
        _viewModel = StateObject(wrappedValue: ChatViewModel(conversationId: conversation.id))
    }

    var body: some View {
        VStack(spacing: 0) {
            messageList
            Divider()
            inputBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.load() }
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message, primaryColor: config.appearance.primaryColor)
                            .id(message.id)
                    }
                }
                .padding()
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let last = viewModel.messages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
    }

    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 8) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Image(systemName: "photo")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            TextField("Message...", text: $messageText, axis: .vertical)
                .lineLimit(1...5)
                .padding(10)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
                .focused($inputFocused)

            Button {
                send()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(messageText.isEmpty ? .secondary : Color(config.appearance.primaryColor))
            }
            .disabled(messageText.isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }

    private func send() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messageText = ""
        viewModel.sendMessage(text)
    }
}
