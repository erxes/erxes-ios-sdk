import Foundation

@MainActor
final class ConversationListViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var error: Error?

    func load(config: ErxesConfig?) {
        guard config != nil else { return }
        isLoading = true
        // TODO: Apollo widgetsConversations query
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            self.isLoading = false
        }
    }

    func startNewConversation() {
        // Handled by AppViewModel.activeConversationId = nil
    }
}
