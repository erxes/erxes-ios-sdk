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
        let base = config.fileEndpoint.hasSuffix("/")
            ? String(config.fileEndpoint.dropLast())
            : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else {
            throw URLError(.badURL)
        }

        let mutation = """
        mutation WidgetTicketCreated(
          $name: String!
          $statusId: String!
          $customerIds: [String!]!
          $description: String
          $attachments: [AttachmentInput]
          $tagIds: [String!]
        ) {
          widgetTicketCreated(
            name: $name
            statusId: $statusId
            customerIds: $customerIds
            description: $description
            attachments: $attachments
            tagIds: $tagIds
          ) {
            _id
            number
          }
        }
        """

        var variables: [String: Any] = [
            "name":        name,
            "statusId":    statusId,
            "customerIds": customerIds,
        ]
        if let description  { variables["description"]  = description }
        if let attachments  { variables["attachments"]  = attachments }
        if let tagIds       { variables["tagIds"]        = tagIds }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query":     mutation,
            "variables": variables
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        SDKLogger.debug("widgetTicketCreated HTTP \(statusCode)")

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        if let errors = json["errors"] as? [[String: Any]] {
            SDKLogger.error("widgetTicketCreated errors: \(errors)")
            let msg = errors.first?["message"] as? String ?? "Unknown error"
            throw NSError(domain: "MessengerSDK", code: 0, userInfo: [NSLocalizedDescriptionKey: msg])
        }

        guard
            let ticket = (json["data"] as? [String: Any])?["widgetTicketCreated"] as? [String: Any],
            let id = ticket["_id"] as? String
        else {
            throw URLError(.cannotParseResponse)
        }

        return CreatedTicket(id: id, number: ticket["number"] as? Int)
    }
}
