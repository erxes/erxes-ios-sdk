import Foundation

public struct Conversation: Identifiable, Codable, Hashable {
    public let id: String
    public let content: String?
    public let createdAt: Date
    public let idleTime: Int?
    public let participatedUsers: [ParticipatedUser]
    public var messages: [Message]

    public var lastMessage: Message? { messages.last }

    /// Timestamp used to order the "Recent" list: the newest message's time, or
    /// the conversation's creation time when it has no messages yet. Sorting by
    /// this (not `createdAt`) keeps freshly-replied conversations at the top.
    public var lastActivityAt: Date { lastMessage?.createdAt ?? createdAt }

    public var unreadCount: Int {
        messages.filter { !$0.isFromCustomer && !(($0.isCustomerRead) ?? false) }.count
    }

    public init(
        id: String,
        content: String?,
        createdAt: Date,
        idleTime: Int? = nil,
        participatedUsers: [ParticipatedUser] = [],
        messages: [Message] = []
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.idleTime = idleTime
        self.participatedUsers = participatedUsers
        self.messages = messages
    }
}

public struct ParticipatedUser: Identifiable, Codable, Hashable {
    public let id: String
    public let details: UserDetails?
    public let isOnline: Bool
}

public struct UserDetails: Codable, Hashable {
    public let avatar: String?
    public let fullName: String?
    public let description: String?
    public let location: String?
    public let position: String?
    public let shortName: String?

    public var displayName: String {
        fullName ?? shortName ?? "Support"
    }
}
