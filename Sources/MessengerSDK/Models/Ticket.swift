import Foundation

public struct Ticket: Identifiable {
    public let id: String
    public let name: String
    public let description: String?
    public let pipelineId: String?
    public let statusId: String?
    public let priority: String?
    public let labelIds: [String]
    public let tagIds: [String]
    public let number: Int?
    public let startDate: Date?
    public let targetDate: Date?
    public let createdAt: Date
    public let updatedAt: Date?
    public let status: TicketStatus?
    public let assignee: TicketAssignee?
}

public struct TicketStatus: Identifiable {
    public let id: String
    public let color: String?
    public let name: String
    public let description: String?
    public let type: String?
}

public struct TicketAssignee: Identifiable {
    public let id: String
    public let details: TicketAssigneeDetails?
}

public struct TicketAssigneeDetails {
    public let avatar: String?
    public let firstName: String?
    public let lastName: String?
    public let fullName: String?

    public var displayName: String {
        fullName ?? [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}
