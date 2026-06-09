import SwiftUI

struct ConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    @Binding var selectedConversation: Conversation?

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.conversations.isEmpty {
                emptyState
            } else {
                list
            }
        }
    }

    private var list: some View {
        List(viewModel.conversations) { conversation in
            NavigationLink(value: conversation) {
                ConversationRowView(conversation: conversation)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
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
            Text("Tap the compose button to start a new conversation.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
