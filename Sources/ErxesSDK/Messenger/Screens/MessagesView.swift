import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = ConversationListViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background
                Color(.systemBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        // Push content below glass header
                        Spacer().frame(height: 90)

                        // Start new card
                        startNewCard
                            .padding(.horizontal, 16)

                        if viewModel.isLoading {
                            ProgressView().padding(.top, 32)
                        } else {
                            conversationCards
                        }

                        if !viewModel.conversations.isEmpty {
                            Text("— end of your conversations —")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                                .padding(.vertical, 16)
                        }

                        Spacer().frame(height: 80) // clear tab bar
                    }
                }

                // Floating glass header
                glassHeader
            }
            .navigationDestination(for: Conversation.self) { conv in
                ChatView(conversation: conv).environmentObject(appVM)
            }
        }
        .onAppear { viewModel.load(config: appVM.config) }
    }

    // MARK: - Glass header

    private var glassHeader: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Messages")
                .font(.caption).foregroundStyle(.secondary)
            Text("Your conversations")
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .liquidGlass(
            shape: RoundedRectangle(cornerRadius: 0)
        )
        .frame(maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Start new card

    private var startNewCard: some View {
        Button {
            appVM.activeConversationId = nil
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "plus")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color(appVM.effectivePrimaryColor), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("Start a new conversation")
                        .font(.subheadline.weight(.semibold))
                    Text(replySubtitle)
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(14)
            .liquidGlassCard(cornerRadius: 18)
        }
        .foregroundStyle(.primary)
    }

    // MARK: - Conversation list as glass cards

    private var conversationCards: some View {
        GlassContainer {
            VStack(spacing: 0) {
                ForEach(viewModel.conversations) { conv in
                    NavigationLink(value: conv) {
                        ConversationRowView(conversation: conv)
                    }
                    .buttonStyle(.plain)
                    if conv.id != viewModel.conversations.last?.id {
                        Divider().padding(.leading, 72)
                    }
                }
            }
            .liquidGlass(
                shape: RoundedRectangle(cornerRadius: 20, style: .continuous),
                shadowRadius: 4
            )
            .padding(.horizontal, 16)
        }
    }

    private var replySubtitle: String {
        guard let md = appVM.messengerData else { return "We'll reply as soon as we can" }
        let base = md.isOnline ? "Replies in ~ 4 minutes" : "We'll reply soon"
        return md.timezone.map { "\(base) · \($0)" } ?? base
    }
}
