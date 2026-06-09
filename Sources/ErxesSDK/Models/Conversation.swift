import Foundation

public struct Conversation: Identifiable, Codable, Hashable {
    public let id: String
    public let content: String?
    public let createdAt: Date
    public var unreadCount: Int
    public var messages: [Message]

    public init(id: String, content: String?, createdAt: Date, unreadCount: Int = 0, messages: [Message] = []) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.unreadCount = unreadCount
        self.messages = messages
    }
}
