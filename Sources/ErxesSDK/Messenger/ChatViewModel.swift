import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var chatRows: [ChatRow] = []
    @Published private(set) var isBotTyping = false
    @Published private(set) var persistentMenu: [PersistentMenuItem] = []
    @Published var pendingAttachments: [UploadedAttachment] = []
    @Published private(set) var isLoading = false

    private let conversationId: String
    private var sendingRef = false   // guard against duplicate sends

    init(conversationId: String) {
        self.conversationId = conversationId
    }

    func load(appVM: AppViewModel) {
        isLoading = true
        // TODO: fetch messages via Apollo widgetsConversationDetail query
        // TODO: subscribe to conversationMessageInserted
        // TODO: subscribe to conversationBotTypingStatus → update isBotTyping
        isLoading = false
    }

    // MARK: - Send

    func sendMessage(_ text: String, appVM: AppViewModel? = nil) {
        guard !sendingRef else { return }
        sendingRef = true

        let optimistic = Message(
            id: ObjectIdGenerator.generate(),
            content: text,
            createdAt: Date(),
            isFromCustomer: true,
            attachments: pendingAttachments.map {
                Attachment(id: ObjectIdGenerator.generate(), url: $0.url, type: $0.type, name: $0.name)
            }
        )
        messages.append(optimistic)
        rebuildRows()
        pendingAttachments = []

        // TODO: execute widgetsInsertMessage mutation via Apollo
        // On success: persist conversationId to SessionManager
        // On failure: remove optimistic message, show error
        sendingRef = false
    }

    // MARK: - Photo attachment

    func attachPhoto(_ item: PhotosPickerItem?, appVM: AppViewModel) async {
        guard let item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self),
              let config = ErxesSDK.shared.config else { return }

        let filename = "photo-\(ObjectIdGenerator.generate()).jpg"
        do {
            let uploaded = try await FileUploader.shared.upload(
                imageData: data,
                filename: filename,
                mimeType: "image/jpeg",
                fileEndpoint: config.fileEndpoint
            )
            pendingAttachments.append(uploaded)
        } catch {
            ErxesLogger.error("Photo upload failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Helpers

    private func rebuildRows() {
        chatRows = MessageGrouper.buildChatRows(messages: messages)
    }
}
