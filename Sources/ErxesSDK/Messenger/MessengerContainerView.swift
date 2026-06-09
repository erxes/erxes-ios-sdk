import SwiftUI

struct MessengerContainerView: View {
    let config: ErxesConfig
    let user: ErxesUser?

    @StateObject private var viewModel = ConversationListViewModel()
    @State private var selectedConversation: Conversation?

    var body: some View {
        NavigationStack {
            ConversationListView(viewModel: viewModel, selectedConversation: $selectedConversation)
                .navigationTitle("Messages")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.startNewConversation()
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(Color(config.appearance.primaryColor))
                    }
                }
        }
        .tint(Color(config.appearance.primaryColor))
        .onAppear {
            viewModel.load(brandCode: config.brandCode, user: user)
        }
        .navigationDestination(for: Conversation.self) { conversation in
            ChatView(conversation: conversation, config: config)
        }
    }
}
