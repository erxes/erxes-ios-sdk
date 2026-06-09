import Foundation
import Combine

@MainActor
final class ConversationListViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var error: Error?

    private var brandCode: String?
    private var user: ErxesUser?

    func load(brandCode: String, user: ErxesUser?) {
        self.brandCode = brandCode
        self.user = user
        fetchConversations()
    }

    func startNewConversation() {
        // TODO: navigate to a blank ChatView for a new conversation
    }

    private func fetchConversations() {
        isLoading = true
        // TODO: replace with real Apollo query
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            self.conversations = []
            self.isLoading = false
        }
    }
}
