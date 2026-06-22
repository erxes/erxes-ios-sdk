import Foundation
import PhotosUI
import SwiftUI

// MARK: - Pending attachment (upload result + thumbnail for the UI)

struct PendingAttachment: Identifiable {
    let id: UUID
    /// nil while the multipart upload is in flight; set when upload succeeds.
    let uploaded: UploadedAttachment?
    /// Local thumbnail generated from the picked image before any network call.
    let thumbnail: UIImage?

    var isUploading: Bool { uploaded == nil }

    init(id: UUID = UUID(), uploaded: UploadedAttachment?, thumbnail: UIImage?) {
        self.id = id
        self.uploaded = uploaded
        self.thumbnail = thumbnail
    }
}

// MARK: - ChatViewModel

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var chatRows: [ChatRow] = []
    @Published private(set) var isBotTyping = false
    @Published private(set) var persistentMenu: [PersistentMenuItem] = []
    @Published var pendingAttachments: [PendingAttachment] = []
    /// Unsent composer text. Lives on the (cached) view model rather than the
    /// view's local @State so it survives switching to another conversation
    /// and back, instead of being wiped when `ChatContentView` is recreated.
    @Published var draftText = ""
    @Published private(set) var isLoading = false
    @Published private(set) var isBot = false
    @Published private(set) var isLoadingMore = false

    /// The backend's `widgetsConversationDetail` query has no limit/offset —
    /// it always returns the full conversation in one shot. Until it grows
    /// pagination args, we fetch everything once and window the rows we
    /// actually render client-side, so long conversations don't pay for
    /// laying out (and grouping) thousands of rows up front.
    private let pageSize = 30
    /// Index into `messages` of the oldest message currently rendered.
    /// `messages[oldestVisibleIndex...]` is what `chatRows` is built from.
    @Published private(set) var oldestVisibleIndex = 0

    var hasMoreMessages: Bool { oldestVisibleIndex > 0 }

    // Mutable so new-conversation sends can update it after the first reply.
    // `private(set)` lets MessagesView read the assigned ID after first send.
    private(set) var conversationId: String
    private var sendingRef = false
    /// Set to true after first successful load. Re-opening the sheet reuses the
    /// cached ViewModel — skip fetch + WS reconnect when already live.
    private var hasLoaded = false

    // WebSocket subscription
    private var wsTask: URLSessionWebSocketTask?
    /// Outer manager — owns reconnect logic. Cancelled only on explicit stopSubscription().
    private var wsManagerTask: Task<Void, Never>?
    private let subscriptionId = UUID().uuidString

    init(conversationId: String) {
        self.conversationId = conversationId
    }

    deinit {
        wsManagerTask?.cancel()
        wsTask?.cancel(with: .goingAway, reason: nil)
    }

    // MARK: - Load messages

    func load(appVM: AppViewModel) {
        // Already loaded — WS is live, messages are in memory. Nothing to do.
        // This path is taken when the user closes and re-opens the same chat sheet.
        guard !hasLoaded else { return }
        guard let config = appVM.config else { return }
        isLoading = true
        Task {
            do {
                let fetched = try await fetchMessages(config: config)
                // Pre-warm content parser cache so first SwiftUI render is instant
                ContentParser.warmCache(contents: fetched.map(\.content))
                messages = fetched
                oldestVisibleIndex = max(0, fetched.count - pageSize)
                isBot = fetched.contains { $0.fromBot == true }
                rebuildRows()
            } catch {
                SDKLogger.error("ChatView fetch failed: \(error)")
            }
            isLoading = false
            hasLoaded = true
            if !conversationId.isEmpty {
                startSubscription(config: config)
                markAsRead(config: config)
            }
        }
    }

    /// Marks all messages in this conversation as read (`widgetsReadConversationMessages`).
    /// Fire-and-forget: failures are logged but never surfaced to the user, since a failed
    /// read receipt should not interrupt the chat.
    private func markAsRead(config: MessengerConfig) {
        guard !conversationId.isEmpty else { return }
        let cid = conversationId
        Task {
            let mutation = """
            mutation WidgetsReadConversationMessages($conversationId: String) {
              widgetsReadConversationMessages(conversationId: $conversationId)
            }
            """
            do {
                try await GraphQL.send(
                    endpoint: config.fileEndpoint,
                    operation: "widgetsReadConversationMessages",
                    query: mutation,
                    variables: ["conversationId": cid]
                )
                SDKLogger.debug("Marked conversation \(cid) as read")
            } catch {
                SDKLogger.error("widgetsReadConversationMessages failed: \(error)")
            }
        }
    }

    func stopSubscription() {
        wsManagerTask?.cancel()
        wsManagerTask = nil
        closeCurrentSocket()
        SDKLogger.debug("WebSocket subscription stopped")
    }

    private func closeCurrentSocket() {
        guard let task = wsTask else { return }
        let complete = ["id": subscriptionId, "type": "complete"]
        if let data = try? JSONSerialization.data(withJSONObject: complete),
           let str = String(data: data, encoding: .utf8) {
            task.send(.string(str)) { _ in }
        }
        task.cancel(with: .goingAway, reason: nil)
        wsTask = nil
    }

    // MARK: - WebSocket subscription (with exponential-backoff reconnect)

    private func startSubscription(config: MessengerConfig) {
        guard wsManagerTask == nil else { return }   // already running

        let base = config.endpoint.hasSuffix("/") ? String(config.endpoint.dropLast()) : config.endpoint
        let wsBase = base
            .replacingOccurrences(of: "https://", with: "wss://")
            .replacingOccurrences(of: "http://",  with: "ws://")
        guard let url = URL(string: "\(wsBase)/gateway/graphql") else { return }

        // Outer manager task — reconnects on transient errors, stops on cancellation.
        wsManagerTask = Task { [weak self] in
            var delay: UInt64 = 1_000_000_000   // start at 1 s
            let maxDelay: UInt64 = 30_000_000_000  // cap at 30 s

            while !Task.isCancelled {
                guard let self else { return }
                do {
                    try await self.runConnection(url: url)
                    // runConnection returned cleanly (server sent "complete") → stop
                    break
                } catch is CancellationError {
                    break   // stopSubscription() was called
                } catch {
                    SDKLogger.error("WS disconnected (\(error)). Reconnecting in \(delay / 1_000_000_000)s…")
                    try? await Task.sleep(nanoseconds: delay)
                    delay = min(delay * 2, maxDelay)
                }
            }
        }
    }

    /// Runs one full connection lifecycle: connect → init → ack → subscribe → receive loop.
    /// Throws on any network error so the manager task can reconnect.
    private func runConnection(url: URL) async throws {
        let task = URLSession.shared.webSocketTask(with: url, protocols: ["graphql-transport-ws"])
        wsTask = task
        task.resume()
        defer { closeCurrentSocket() }

        // 1. connection_init
        try await wsSend(task, payload: ["type": "connection_init"])
        SDKLogger.debug("WS → connection_init")

        // 2. connection_ack
        try await waitForAck(task)
        SDKLogger.debug("WS ← connection_ack")

        // 3. subscribe
        let subscribePayload: [String: Any] = [
            "id": subscriptionId,
            "type": "subscribe",
            "payload": [
                "query": """
                subscription ConversationMessageInserted($_id: String!) {
                  conversationMessageInserted(_id: $_id) {
                    _id
                    content
                    createdAt
                    customerId
                    userId
                    isCustomerRead
                    fromBot
                    user {
                      _id
                      details {
                        avatar
                        fullName
                      }
                    }
                    attachments {
                      url
                      name
                      size
                      type
                    }
                  }
                }
                """,
                "variables": ["_id": conversationId]
            ]
        ]
        try await wsSend(task, payload: subscribePayload)
        SDKLogger.debug("WS → subscribe conversationMessageInserted(\(conversationId))")

        // 4. Receive loop — throws on connection drop so the manager reconnects
        while !Task.isCancelled {
            let msg = try await task.receive()
            let shouldStop = await handleWsMessage(msg)
            if shouldStop { return }   // server sent "complete" — clean stop
        }
    }

    private func wsSend(_ task: URLSessionWebSocketTask, payload: [String: Any]) async throws {
        let data = try JSONSerialization.data(withJSONObject: payload)
        guard let str = String(data: data, encoding: .utf8) else { return }
        try await task.send(.string(str))
    }

    private func waitForAck(_ task: URLSessionWebSocketTask) async throws {
        // Read messages until we get connection_ack (ignore pings etc.)
        for _ in 0..<10 {
            let msg = try await task.receive()
            if case .string(let str) = msg,
               let json = try? JSONSerialization.jsonObject(with: Data(str.utf8)) as? [String: Any],
               json["type"] as? String == "connection_ack" {
                return
            }
        }
        // No ack within 10 frames — throw so the manager task reconnects instead of
        // subscribing over a half-open connection.
        throw GraphQL.GraphQLError(message: "WebSocket connection_ack not received")
    }

    /// Returns `true` when the server sends "complete" (clean stop, no reconnect needed).
    @MainActor
    private func handleWsMessage(_ wsMsg: URLSessionWebSocketTask.Message) async -> Bool {
        guard case .string(let str) = wsMsg,
              let json = try? JSONSerialization.jsonObject(with: Data(str.utf8)) as? [String: Any]
        else { return false }

        let type_ = json["type"] as? String ?? ""

        switch type_ {
        case "next":
            guard let payload = json["payload"] as? [String: Any],
                  let data = payload["data"] as? [String: Any],
                  let raw = data["conversationMessageInserted"] as? [String: Any],
                  let msg = parseMessage(raw) else { return false }
            // Deduplicate — subscription fires for our own sent messages too
            guard !messages.contains(where: { $0.id == msg.id }) else { return false }
            messages.append(msg)
            if msg.fromBot == true { isBot = true }
            rebuildRows()
            SDKLogger.debug("WS ← new message \(msg.id)")
            // An inbound message (from an agent/bot, not the customer) means there's
            // something new to mark read while the chat is open.
            if !msg.isFromCustomer, let config = MessengerSDK.shared.config {
                markAsRead(config: config)
            }
            return false

        case "error":
            SDKLogger.error("WS subscription error: \(str)")
            return false

        case "complete":
            SDKLogger.debug("WS subscription completed by server")
            return true   // server closed cleanly — don't reconnect

        default:
            return false
        }
    }

    // MARK: - GraphQL fetch

    private func fetchMessages(config: MessengerConfig) async throws -> [Message] {
        // New conversation — no ID yet, nothing to fetch
        guard !conversationId.isEmpty else { return [] }

        let query = """
        query WidgetsConversationDetail($_id: String, $integrationId: String!) {
          widgetsConversationDetail(_id: $_id, integrationId: $integrationId) {
            _id
            messages {
              _id
              conversationId
              customerId
              attachments {
                name
                url
              }
              user {
                _id
                details {
                  avatar
                  fullName
                }
              }
              content
              createdAt
              fromBot
              contentType
              internal
            }
          }
        }
        """
        let json = try await GraphQL.send(
            endpoint: config.fileEndpoint,
            operation: "widgetsConversationDetail",
            query: query,
            variables: [
                "_id": conversationId,
                "integrationId": config.integrationId
            ]
        )

        guard let detail = ((json["data"] as? [String: Any])?["widgetsConversationDetail"]) as? [String: Any],
              let rawMessages = detail["messages"] as? [[String: Any]] else { return [] }

        return rawMessages.compactMap { parseMessage($0) }
    }

    private func parseMessage(_ m: [String: Any]) -> Message? {
        guard let id = m["_id"] as? String else { return nil }
        let content = (m["content"] as? String) ?? ""
        let createdAt = DateParsing.date(from: m["createdAt"]) ?? Date()
        let customerId = m["customerId"] as? String
        // A message is "from customer" only when customerId is present AND non-empty;
        // an empty string would otherwise render an agent message on the customer side.
        let isFromCustomer = !(customerId?.isEmpty ?? true)
        let fromBot = m["fromBot"] as? Bool

        // Attachments
        let attachments: [Attachment] = (m["attachments"] as? [[String: Any]] ?? []).compactMap { a in
            guard let url = a["url"] as? String else { return nil }
            return Attachment(
                id: ObjectIdGenerator.generate(),
                url: url,
                type: (a["type"] as? String) ?? "image",
                name: a["name"] as? String,
                size: a["size"] as? Int
            )
        }

        // User
        var messageUser: MessageUser?
        if let u = m["user"] as? [String: Any], let uid = u["_id"] as? String {
            var details: UserDetails?
            if let d = u["details"] as? [String: Any] {
                details = UserDetails(
                    avatar: d["avatar"] as? String,
                    fullName: d["fullName"] as? String,
                    description: nil,
                    location: nil,
                    position: nil,
                    shortName: nil
                )
            }
            messageUser = MessageUser(id: uid, isOnline: nil, details: details)
        }

        return Message(
            id: id,
            content: content,
            createdAt: createdAt,
            isFromCustomer: isFromCustomer,
            attachments: attachments,
            fromBot: fromBot,
            customerId: customerId,
            conversationId: m["conversationId"] as? String,
            userId: m["userId"] as? String,
            isCustomerRead: nil,
            user: messageUser
        )
    }

    // MARK: - Send

    func sendMessage(_ text: String, appVM: AppViewModel? = nil) {
        guard !sendingRef, let appVM else { return }
        guard let config = appVM.config else { return }
        sendingRef = true

        let optimisticId = ObjectIdGenerator.generate()
        // Only send attachments that finished uploading — skip any still in-flight.
        let attachmentsCopy = pendingAttachments.filter { !$0.isUploading }
        let optimistic = Message(
            id: optimisticId,
            content: text,
            createdAt: Date(),
            isFromCustomer: true,
            attachments: attachmentsCopy.compactMap { pending in
                guard let up = pending.uploaded else { return nil }
                return Attachment(
                    id: ObjectIdGenerator.generate(),
                    url: up.url,
                    type: up.type,
                    name: up.name,
                    size: up.size
                )
            }
        )
        messages.append(optimistic)
        rebuildRows()
        pendingAttachments = []

        Task {
            defer { sendingRef = false }
            do {
                let sent = try await insertMessage(
                    text: text,
                    attachments: attachmentsCopy.compactMap(\.uploaded),
                    config: config,
                    customerId: appVM.customerId,
                    visitorId: SessionManager.shared.visitorId
                )
                // Replace optimistic with real message — unless the WebSocket
                // subscription already delivered this same message (it doesn't
                // know about our temp ID, so its own dedup check can't catch
                // this case). If so, just drop the placeholder instead of
                // inserting a second row with the same id.
                if let idx = messages.firstIndex(where: { $0.id == optimisticId }) {
                    if messages.contains(where: { $0.id == sent.id }) {
                        messages.remove(at: idx)
                    } else {
                        messages[idx] = sent
                    }
                }
                // For new conversations: store the returned conversationId and
                // start the WebSocket subscription so future messages arrive live.
                if let cid = sent.conversationId {
                    SessionManager.shared.lastConversationId = cid
                    if conversationId.isEmpty {
                        conversationId = cid
                        startSubscription(config: config)
                    }
                }
                rebuildRows()
            } catch {
                SDKLogger.error("widgetsInsertMessage failed: \(error)")
                messages.removeAll { $0.id == optimisticId }
                rebuildRows()
            }
        }
    }

    private func insertMessage(
        text: String,
        attachments: [UploadedAttachment],
        config: MessengerConfig,
        customerId: String?,
        visitorId: String
    ) async throws -> Message {
        let mutation = """
        mutation WidgetsInsertMessage(
          $integrationId: String!
          $customerId: String
          $visitorId: String
          $conversationId: String
          $contentType: String
          $message: String
          $attachments: [AttachmentInput]
        ) {
          widgetsInsertMessage(
            integrationId: $integrationId
            customerId: $customerId
            visitorId: $visitorId
            conversationId: $conversationId
            contentType: $contentType
            message: $message
            attachments: $attachments
          ) {
            _id
            conversationId
            customerId
            user {
              _id
              details {
                avatar
                fullName
              }
            }
            content
            createdAt
            fromBot
            contentType
            attachments {
              url
              name
              size
              type
            }
          }
        }
        """

        var variables: [String: Any] = [
            "integrationId": config.integrationId,
            "visitorId": visitorId,
            "contentType": "text",
            "message": text
        ]
        // Only include conversationId when we have one — omitting it tells the
        // server to create a new conversation.
        if !conversationId.isEmpty {
            variables["conversationId"] = conversationId
        }
        if let cid = customerId {
            variables["customerId"] = cid
        }
        if !attachments.isEmpty {
            variables["attachments"] = attachments.map {[
                "url":  $0.url,
                "name": $0.name,
                "type": $0.type,
                "size": $0.size
            ]}
        }

        let raw = try await GraphQL.object(
            endpoint: config.fileEndpoint,
            operation: "widgetsInsertMessage",
            query: mutation,
            variables: variables,
            field: "widgetsInsertMessage"
        )
        guard let parsed = parseMessage(raw) else {
            throw GraphQL.GraphQLError(message: "Failed to parse message")
        }
        return parsed
    }

    // MARK: - Photo attachment

    func attachPhoto(_ item: PhotosPickerItem, appVM: AppViewModel) async {
        guard let config = MessengerSDK.shared.config else { return }

        // Declared outside the do/catch so the failure path can remove this exact
        // placeholder without touching other in-flight uploads.
        let placeholderID = UUID()

        do {
            // 1. Decode image locally (fast, no network).
            // Round-trip through UIImage → jpegData converts HEIC → JPEG and strips EXIF.
            guard let rawData = try await item.loadTransferable(type: Data.self),
                  let uiImage   = UIImage(data: rawData),
                  let jpegData  = uiImage.jpegData(compressionQuality: 0.85) else {
                SDKLogger.error("Photo attachment: could not decode image data")
                return
            }

            // 2. Generate thumbnail immediately so the placeholder shows the image
            //    before the upload even starts.
            let thumb = uiImage.preparingThumbnail(of: CGSize(width: 120, height: 120))

            // 3. Insert placeholder (uploaded = nil → isUploading = true).
            //    The strip shows this instantly with a spinner overlay.
            pendingAttachments.append(
                PendingAttachment(id: placeholderID, uploaded: nil, thumbnail: thumb)
            )

            // 4. Run the multipart POST upload.
            let originalName = item.itemIdentifier
                .flatMap { $0.components(separatedBy: "/").last }
                ?? "photo-\(ObjectIdGenerator.generate()).jpg"
            let filename = originalName.hasSuffix(".jpg") || originalName.hasSuffix(".jpeg")
                ? originalName : "\(originalName).jpg"

            let uploaded = try await FileUploader.shared.upload(
                fileData: jpegData,
                filename: filename,
                mimeType: "image/jpeg",
                fileEndpoint: config.fileEndpoint
            )

            // 5. Replace placeholder with the completed upload in-place (keeps strip order).
            if let idx = pendingAttachments.firstIndex(where: { $0.id == placeholderID }) {
                pendingAttachments[idx] = PendingAttachment(
                    id: placeholderID,
                    uploaded: uploaded,
                    thumbnail: thumb
                )
            }
        } catch {
            SDKLogger.error("Photo upload failed: \(error.localizedDescription)")
            // Remove only THIS placeholder so a concurrent upload's spinner survives.
            pendingAttachments.removeAll { $0.id == placeholderID }
        }
    }

    // MARK: - Pagination

    /// Reveals the previous page of already-fetched messages. Called when the
    /// chat scrolls to its topmost row. Pure client-side windowing today — the
    /// brief delay just keeps the loading affordance consistent with what a
    /// real network page-fetch would feel like, so this slots in unchanged if
    /// the backend ever adds limit/offset to `widgetsConversationDetail`.
    func loadOlderMessagesIfNeeded() {
        guard !isLoadingMore, hasMoreMessages else { return }
        isLoadingMore = true
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            oldestVisibleIndex = max(0, oldestVisibleIndex - pageSize)
            rebuildRows()
            isLoadingMore = false
        }
    }

    // MARK: - Helpers

    private func rebuildRows() {
        // Clamp defensively — an optimistic-message rollback can shrink
        // `messages` by one without touching `oldestVisibleIndex`.
        let start = min(oldestVisibleIndex, messages.count)
        chatRows = MessageGrouper.buildChatRows(messages: Array(messages[start...]))
    }
}
