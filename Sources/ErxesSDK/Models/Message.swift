import Foundation

public struct Message: Identifiable, Codable, Hashable {
    public let id: String
    public let content: String
    public let createdAt: Date
    public let isFromCustomer: Bool
    public let attachments: [Attachment]

    public init(id: String, content: String, createdAt: Date, isFromCustomer: Bool, attachments: [Attachment] = []) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.isFromCustomer = isFromCustomer
        self.attachments = attachments
    }
}

public struct Attachment: Identifiable, Codable, Hashable {
    public let id: String
    public let url: String
    public let type: String
    public let name: String?
}
