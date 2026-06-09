import SwiftUI

// Legacy wrapper — MessagesView is now the primary conversations screen.
// Kept for direct NavigationStack usage if needed.
struct ConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    @Binding var selectedConversation: Conversation?

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.conversations.isEmpty {
                emptyState
            } else {
                list
            }
        }
    }

    private var list: some View {
        List(viewModel.conversations) { conv in
            NavigationLink(value: conv) {
                ConversationRowView(conversation: conv)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No conversations yet")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
