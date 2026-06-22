import SwiftUI

/// The classic chat sheet: wraps `ChatContentView` in a `NavigationStack` and
/// supplies the navigation toolbar (dismiss button + conversation title). The
/// message list, input bar, photo picker and swipe-to-reveal timestamps all live
/// in `ChatContentView`, which is shared with chat mode (`MessengerChatModeView`).
struct ChatView: View {
    let conversation: Conversation
    /// When set, this message is sent automatically once the chat finishes loading.
    let autoSendMessage: String?

    // @ObservedObject — ChatView observes but does NOT own the ViewModel.
    // Ownership lives in MessagesView's cache so the WS subscription survives
    // sheet dismiss/reopen without reconnecting.
    @ObservedObject var viewModel: ChatViewModel

    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss

    init(conversation: Conversation, viewModel: ChatViewModel, autoSendMessage: String? = nil) {
        self.conversation = conversation
        self.viewModel = viewModel
        self.autoSendMessage = autoSendMessage
    }

    var body: some View {
        NavigationStack {
            ChatContentView(
                conversation: conversation,
                viewModel: viewModel,
                autoSendMessage: autoSendMessage
            )
            .environmentObject(appVM)
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
                    ChatTitleView(conversation: conversation, viewModel: viewModel)
                        .environmentObject(appVM)
                }
                // Invisible trailing item matching the leading button's width so the
                // bar's leading/trailing slots are balanced and the principal title
                // is actually centered, not just centered in the leftover space.
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .opacity(0)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
