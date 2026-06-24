import Foundation

@MainActor
final class ConversationListViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var error: String?

    // MARK: - Load

    func load(appVM: AppViewModel) {
        guard let config = appVM.config else { return }
        isLoading = true
        error = nil
        Task {
            do {
                conversations = try await fetchConversations(
                    config: config,
                    customerId: appVM.customerId,
                    visitorId: appVM.visitorId
                )
            } catch {
                SDKLogger.error("ConversationList fetch failed: \(error)")
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    // MARK: - GraphQL

    private func fetchConversations(
        config: MessengerConfig,
        customerId: String?,
        visitorId: String?
    ) async throws -> [Conversation] {
        var variables: [String: Any] = ["integrationId": config.integrationId]
        // Mirror the identity rule: prefer the registered customerId, fall back
        // to the guest visitorId. They are mutually exclusive on the backend.
        if let customerId, !customerId.isEmpty {
            variables["customerId"] = customerId
        } else if let visitorId, !visitorId.isEmpty {
            variables["visitorId"] = visitorId
        }

        let list = try await GraphQL.array(
            endpoint: config.fileEndpoint,
            operation: "widgetsConversations",
            query: MessengerGraphQL.conversations,
            variables: variables,
            field: "widgetsConversations"
        )

        // Order by latest activity (newest message), not creation time — an old
        // conversation with a fresh reply must rank above a newer but idle one.
        return list.compactMap { parseConversation($0) }
            .sorted { $0.lastActivityAt > $1.lastActivityAt }
    }

    // MARK: - Parsers

    private func parseConversation(_ d: [String: Any]) -> Conversation? {
        guard let rawId = d["_id"] as? String else { return nil }

        let createdAt = DateParsing.date(from: d["createdAt"]) ?? Date()

        let users: [ParticipatedUser] = (d["participatedUsers"] as? [[String: Any]] ?? [])
            .compactMap { u in
                guard let uid = u["_id"] as? String else { return nil }
                let det = u["details"] as? [String: Any]
                return ParticipatedUser(
                    id: uid,
                    details: det.map { parseUserDetails($0) },
                    isOnline: u["isOnline"] as? Bool ?? false
                )
            }

        let messages: [Message] = (d["messages"] as? [[String: Any]] ?? [])
            .compactMap { parseMessage($0) }
            .sorted { $0.createdAt < $1.createdAt }

        return Conversation(
            id: rawId,
            content: d["content"] as? String,
            createdAt: createdAt,
            idleTime: d["idleTime"] as? Int,
            participatedUsers: users,
            messages: messages
        )
    }

    private func parseMessage(_ d: [String: Any]) -> Message? {
        guard let mid = d["_id"] as? String else { return nil }
        // Bot messages have `content: null` and carry their text in `botData`
        // (`[{ type, text }]`) — fall back to it so list previews aren't blank.
        var content = d["content"] as? String ?? ""
        if content.isEmpty, let botData = d["botData"] as? [[String: Any]] {
            content = botData
                .compactMap { $0["text"] as? String }
                .joined(separator: "\n")
        }
        let customerId = d["customerId"] as? String
        let userId = d["userId"] as? String
        let isFromCustomer = customerId != nil && !(customerId?.isEmpty ?? true)

        let attachments: [Attachment] = (d["attachments"] as? [[String: Any]] ?? [])
            .compactMap { a in
                guard let aUrl = a["url"] as? String else { return nil }
                return Attachment(
                    id: UUID().uuidString,
                    url: aUrl,
                    type: a["type"] as? String ?? "file",
                    name: a["name"] as? String,
                    size: a["size"] as? Int
                )
            }

        var msgUser: MessageUser?
        if let u = d["user"] as? [String: Any], let uid = u["_id"] as? String {
            let det = u["details"] as? [String: Any]
            msgUser = MessageUser(
                id: uid,
                isOnline: u["isOnline"] as? Bool ?? false,
                details: det.map { parseUserDetails($0) }
            )
        }

        return Message(
            id: mid,
            content: content,
            createdAt: DateParsing.date(from: d["createdAt"]) ?? Date(),
            isFromCustomer: isFromCustomer,
            attachments: attachments,
            fromBot: d["fromBot"] as? Bool,
            customerId: customerId,
            userId: userId,
            isCustomerRead: d["isCustomerRead"] as? Bool,
            user: msgUser
        )
    }

    private func parseUserDetails(_ d: [String: Any]) -> UserDetails {
        UserDetails(
            avatar:      d["avatar"]    as? String,
            fullName:    d["fullName"]  as? String,
            description: d["description"] as? String,
            location:    d["location"]  as? String,
            position:    d["position"]  as? String,
            shortName:   d["shortName"] as? String
        )
    }
}
