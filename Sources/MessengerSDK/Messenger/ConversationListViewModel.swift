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
        let base = config.fileEndpoint.hasSuffix("/")
            ? String(config.fileEndpoint.dropLast())
            : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else {
            throw URLError(.badURL)
        }

        let query = """
        query widgetsConversations($integrationId: String!, $customerId: String, $visitorId: String) {
          widgetsConversations(
            integrationId: $integrationId
            customerId: $customerId
            visitorId: $visitorId
          ) {
            _id
            content
            createdAt
            idleTime
            participatedUsers {
              _id
              details {
                avatar
                fullName
                shortName
              }
              isOnline
            }
            messages {
              _id
              createdAt
              content
              fromBot
              customerId
              isCustomerRead
              userId
              attachments {
                url
                name
                size
                type
              }
              user {
                _id
                isOnline
                details {
                  avatar
                  fullName
                  shortName
                }
              }
            }
          }
        }
        """

        var variables: [String: Any] = ["integrationId": config.integrationId]
        // TODO: remove hardcoded test customerId
        let resolvedCustomerId = "uRXZqhB7iT5AKii3IzC8d"
        variables["customerId"] = resolvedCustomerId
        _ = customerId; _ = visitorId

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query": query,
            "variables": variables
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        SDKLogger.debug("widgetsConversations HTTP \(statusCode)")

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        if let errs = json["errors"] as? [[String: Any]] {
            SDKLogger.error("widgetsConversations errors: \(errs)")
        }

        guard let list = (json["data"] as? [String: Any])?["widgetsConversations"] as? [[String: Any]] else {
            return []
        }

        return list.compactMap { parseConversation($0) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    // MARK: - Parsers

    private func parseConversation(_ d: [String: Any]) -> Conversation? {
        guard let rawId = d["_id"] as? String else { return nil }

        let createdAt = parseDate(d["createdAt"]) ?? Date()

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
        let content = d["content"] as? String ?? ""
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
            createdAt: parseDate(d["createdAt"]) ?? Date(),
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

    /// Handles ISO8601 strings ("2024-01-15T10:30:00.000Z") and Unix ms numbers.
    private func parseDate(_ value: Any?) -> Date? {
        if let ms = value as? Double  { return Date(timeIntervalSince1970: ms / 1_000) }
        if let ms = value as? Int     { return Date(timeIntervalSince1970: Double(ms) / 1_000) }
        if let str = value as? String {
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = f.date(from: str) { return d }
            f.formatOptions = [.withInternetDateTime]
            return f.date(from: str)
        }
        return nil
    }
}
