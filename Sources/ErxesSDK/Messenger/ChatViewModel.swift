import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading = false

    private let conversationId: String

    init(conversationId: String) {
        self.conversationId = conversationId
    }

    func load() {
        isLoading = true
        // TODO: fetch messages via Apollo query + subscribe via WebSocket
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            self.isLoading = false
        }
    }

    func sendMessage(_ text: String) {
        let optimistic = Message(
            id: UUID().uuidString,
            content: text,
            createdAt: Date(),
            isFromCustomer: true
        )
        messages.append(optimistic)
        // TODO: send via Apollo mutation, replace optimistic message with server response
    }
}
