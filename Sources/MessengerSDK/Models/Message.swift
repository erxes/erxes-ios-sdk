import Foundation

public struct Message: Identifiable, Codable, Hashable {
    public let id: String
    public let content: String
    public let createdAt: Date
    public let isFromCustomer: Bool   // true when customerId is set
    public let attachments: [Attachment]
    public let fromBot: Bool?
    public let customerId: String?
    public let conversationId: String?
    public let userId: String?
    public let isCustomerRead: Bool?
    public let user: MessageUser?     // agent who sent the message

    public init(
        id: String,
        content: String,
        createdAt: Date,
        isFromCustomer: Bool,
        attachments: [Attachment] = [],
        fromBot: Bool? = nil,
        customerId: String? = nil,
        conversationId: String? = nil,
        userId: String? = nil,
        isCustomerRead: Bool? = nil,
        user: MessageUser? = nil
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.isFromCustomer = isFromCustomer
        self.attachments = attachments
        self.fromBot = fromBot
        self.customerId = customerId
        self.conversationId = conversationId
        self.userId = userId
        self.isCustomerRead = isCustomerRead
        self.user = user
    }
}

public struct MessageUser: Codable, Hashable {
    public let id: String
    public let isOnline: Bool?
    public let details: UserDetails?
}

public struct Attachment: Identifiable, Codable, Hashable {
    public let id: String
    public let url: String
    public let type: String
    public let name: String?
    public let size: Int?
}
