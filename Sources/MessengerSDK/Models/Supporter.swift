import Foundation

public struct Supporter: Identifiable {
    public let id: String
    public let fullName: String?
    public let avatar: String?   // raw key, resolved via AttachmentURL
    public let isOnline: Bool
}
