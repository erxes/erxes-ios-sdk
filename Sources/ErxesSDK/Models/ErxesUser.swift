import Foundation

public struct ErxesUser {
    public let email: String?
    public let phone: String?
    public let name: String?
    public let customData: [String: String]

    public init(
        email: String? = nil,
        phone: String? = nil,
        name: String? = nil,
        customData: [String: String] = [:]
    ) {
        self.email = email
        self.phone = phone
        self.name = name
        self.customData = customData
    }
}
