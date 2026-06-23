import Foundation

struct CreatedTicket {
    let id: String
    let number: Int?
}

struct TicketMutations {

    /// Executes `widgetTicketCreated` and returns the new ticket's id and number.
    static func createTicket(
        config: MessengerConfig,
        name: String,
        statusId: String,
        customerIds: [String],
        description: String? = nil,
        attachments: [[String: Any]]? = nil,
        tagIds: [String]? = nil
    ) async throws -> CreatedTicket {
        var variables: [String: Any] = [
            "name":        name,
            "statusId":    statusId,
            "customerIds": customerIds,
        ]
        if let description  { variables["description"]  = description }
        if let attachments  { variables["attachments"]  = attachments }
        if let tagIds       { variables["tagIds"]        = tagIds }

        let ticket = try await GraphQL.object(
            endpoint: config.fileEndpoint,
            operation: "widgetTicketCreated",
            query: MessengerGraphQL.createTicket,
            variables: variables,
            field: "widgetTicketCreated"
        )
        guard let id = ticket["_id"] as? String else {
            throw GraphQL.GraphQLError(message: "Failed to parse widgetTicketCreated")
        }

        return CreatedTicket(id: id, number: ticket["number"] as? Int)
    }
}
