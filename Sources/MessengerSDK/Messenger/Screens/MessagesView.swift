import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var listVM = ConversationListViewModel()
    @State private var selectedConversation: Conversation?

    // ── Existing-conversation VM cache ────────────────────────────────────────
    // Keyed by conversation ID. MessagesView owns all ChatViewModels — ChatView
    // only observes them (@ObservedObject). This means the WS subscription
    // survives sheet dismiss/reopen because the ViewModel is never deallocated.
    @State private var chatVMCache: [String: ChatViewModel] = [:]

    // ── New-conversation state ────────────────────────────────────────────────
    // Bundles the VM + optional auto-send text into one Identifiable item so
    // `.sheet(item:)` can guarantee both are non-nil when the sheet opens.
    // Using two separate @State vars + isPresented had a timing bug where
    // newConvVM could evaluate as nil in the sheet content closure.
    @State private var newChatContext: NewChatContext? = nil

    private struct NewChatContext: Identifiable {
        let id = UUID()
        let vm: ChatViewModel
        let autoSend: String?
    }

    // ── requireAuth state ─────────────────────────────────────────────────────
    // When the integration requires auth and the visitor isn't identified yet, we
    // present the identity form first, then chain into the chat once it succeeds.
    @State private var authContext: AuthContext? = nil
    @State private var pendingAutoSendAfterAuth: String? = nil
    @State private var didAuthenticate = false

    private struct AuthContext: Identifiable {
        let id = UUID()
        let autoSend: String?
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                PageHeroHeader(title: "Messages", subtitle: "Your conversations")
                    .environmentObject(appVM)

                VStack(spacing: 12) {
                    // When the integration requires auth and the visitor isn't
                    // identified yet, show only the inline email/phone capture form —
                    // the "start a new conversation" card and the conversation list
                    // stay hidden until they've identified. Once saved (identified),
                    // the normal start card + list appear.
                    if appVM.requireAuth && !appVM.isIdentified {
                        inlineAuthForm
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    } else {
                        startNewCard
                            .padding(.horizontal, 16)
                            .padding(.top, 16)

                        if listVM.isLoading {
                            ProgressView().padding(.top, 32)
                        } else {
                            conversationCards
                        }

                        if !listVM.conversations.isEmpty {
                            Text("— end of your conversations —")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                                .padding(.vertical, 16)
                        }
                    }

                    Spacer().frame(height: 80)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            listVM.load(appVM: appVM)
            // Catch a home-bar message set BEFORE this view first mounted — on the
            // very first home send, MessagesView isn't in the hierarchy yet, so the
            // .onChange below never fires for it. Draining here covers that case.
            consumePendingHomeMessage()
        }

        // ── Existing conversation sheet ───────────────────────────────────────
        .sheet(item: $selectedConversation) { conv in
            ChatView(
                conversation: conv,
                viewModel: existingVM(for: conv)
            )
            .environmentObject(appVM)
            .onDisappear {
                // Messages that arrived live (via the chat's WS subscription) only
                // updated that ChatViewModel — the list still holds the old last
                // message/content. Refresh so the row reflects the latest message.
                listVM.load(appVM: appVM)
            }
        }

        // ── New conversation sheet ────────────────────────────────────────────
        // .sheet(item:) guarantees `ctx` is non-nil — no if-let needed.
        .sheet(item: $newChatContext) { ctx in
            ChatView(
                conversation: Conversation(id: "", content: nil, createdAt: Date()),
                viewModel: ctx.vm,
                autoSendMessage: ctx.autoSend
            )
            .environmentObject(appVM)
            .onDisappear {
                // Graduate the VM into the cache if a real conversation ID was
                // assigned after the first message was sent.
                if !ctx.vm.conversationId.isEmpty {
                    chatVMCache[ctx.vm.conversationId] = ctx.vm
                    // Refresh the list so the just-created conversation appears.
                    listVM.load(appVM: appVM)
                }
            }
        }

        // ── requireAuth identity form ─────────────────────────────────────────
        // On success, stash the auto-send text and flag; the onDismiss handler then
        // opens the chat (isIdentified is now true, so it won't re-show the form).
        .sheet(item: $authContext, onDismiss: {
            guard didAuthenticate else { return }
            didAuthenticate = false
            let send = pendingAutoSendAfterAuth
            pendingAutoSendAfterAuth = nil
            openNewConversation(autoSend: send)
        }) { ctx in
            GetNotifiedView {
                pendingAutoSendAfterAuth = ctx.autoSend
                didAuthenticate = true
                authContext = nil   // triggers onDismiss → opens the chat
            }
            .environmentObject(appVM)
            .presentationDetents([.medium, .large])
        }

        // Home input bar → open a new chat and auto-send the typed text.
        // Fires when MessagesView is already mounted and the value changes.
        .onChange(of: appVM.pendingHomeMessage) { _ in
            consumePendingHomeMessage()
        }
    }

    /// Opens a new-conversation sheet for a pending home-bar message, if any.
    /// Idempotent: nils the value immediately so the .onAppear and .onChange paths
    /// can't both open a sheet for the same message.
    private func consumePendingHomeMessage() {
        guard let msg = appVM.pendingHomeMessage else { return }
        appVM.pendingHomeMessage = nil
        openNewConversation(autoSend: msg)
    }

    // MARK: - VM helpers

    /// Returns a cached ChatViewModel for an existing conversation, creating one
    /// on first access. The VM owns the WS subscription for its lifetime.
    private func existingVM(for conv: Conversation) -> ChatViewModel {
        if let cached = chatVMCache[conv.id] { return cached }
        let vm = ChatViewModel(conversationId: conv.id)
        chatVMCache[conv.id] = vm
        return vm
    }

    /// Opens the new-conversation sheet. VM and autoSend are bundled into one
    /// Identifiable item so `.sheet(item:)` receives them atomically — no race.
    private func openNewConversation(autoSend: String? = nil) {
        // requireAuth: capture an email/phone before the first conversation.
        if appVM.requireAuth && !appVM.isIdentified {
            authContext = AuthContext(autoSend: autoSend)
            return
        }
        newChatContext = NewChatContext(
            vm: ChatViewModel(conversationId: ""),
            autoSend: autoSend
        )
    }

    // MARK: - Inline identity form (requireAuth)

    /// The requireAuth email/phone capture form, embedded as a card inside the
    /// tab. On success `isIdentified` flips true (so this view is replaced by the
    /// start card) and we open the new conversation.
    private var inlineAuthForm: some View {
        GetNotifiedView(embedded: true) {
            openNewConversation()
        }
        .environmentObject(appVM)
        .liquidGlassCard(cornerRadius: 18)
    }

    // MARK: - Start new card

    private var startNewCard: some View {
        Button { openNewConversation() } label: {
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

    // MARK: - Conversation list

    private var conversationCards: some View {
        GlassContainer {
            VStack(spacing: 0) {
                ForEach(listVM.conversations) { conv in
                    Button { selectedConversation = conv } label: {
                        ConversationRowView(conversation: conv)
                    }
                    .buttonStyle(.plain)

                    if conv.id != listVM.conversations.last?.id {
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
