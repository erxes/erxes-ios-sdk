import Foundation

@MainActor
final class TicketListViewModel: ObservableObject {
    @Published var tickets: [Ticket] = []
    @Published var isLoading = false
    @Published var error: String?

    func load(appVM: AppViewModel) {
        guard let config = appVM.config else { return }
        isLoading = true
        error = nil
        Task {
            do {
                tickets = try await fetchTickets(config: config, customerId: appVM.customerId)
            } catch {
                SDKLogger.error("TicketList fetch failed: \(error)")
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    // MARK: - GraphQL

    private func fetchTickets(config: MessengerConfig, customerId: String?) async throws -> [Ticket] {
        let query = """
        query WidgetTicketsByCustomer($customerId: String) {
          widgetTicketsByCustomer(customerId: $customerId) {
            _id
            name
            description
            pipelineId
            statusId
            priority
            labelIds
            tagIds
            number
            startDate
            targetDate
            createdAt
            updatedAt
            status {
              _id
              color
              name
              description
              type
            }
            assignee {
              _id
              details {
                avatar
                firstName
                lastName
                fullName
              }
            }
          }
        }
        """

        var variables: [String: Any] = [:]
        if let cid = customerId, !cid.isEmpty { variables["customerId"] = cid }

        let list = try await GraphQL.array(
            endpoint: config.fileEndpoint,
            operation: "widgetTicketsByCustomer",
            query: query,
            variables: variables,
            field: "widgetTicketsByCustomer"
        )

        return list.compactMap { parseTicket($0) }
            .sorted { ($0.createdAt) > ($1.createdAt) }
    }

    // MARK: - Parser

    private func parseTicket(_ d: [String: Any]) -> Ticket? {
        guard let id = d["_id"] as? String else { return nil }

        var status: TicketStatus?
        if let s = d["status"] as? [String: Any], let sid = s["_id"] as? String {
            status = TicketStatus(
                id: sid,
                color: s["color"] as? String,
                name: s["name"] as? String ?? "",
                description: s["description"] as? String,
                type: s["type"] as? String
            )
        }

        var assignee: TicketAssignee?
        if let a = d["assignee"] as? [String: Any], let aid = a["_id"] as? String {
            let det = a["details"] as? [String: Any]
            assignee = TicketAssignee(
                id: aid,
                details: det.map {
                    TicketAssigneeDetails(
                        avatar:    $0["avatar"]    as? String,
                        firstName: $0["firstName"] as? String,
                        lastName:  $0["lastName"]  as? String,
                        fullName:  $0["fullName"]  as? String
                    )
                }
            )
        }

        return Ticket(
            id: id,
            name: d["name"] as? String ?? "",
            description: d["description"] as? String,
            pipelineId: d["pipelineId"] as? String,
            statusId: d["statusId"] as? String,
            priority: d["priority"] as? String,
            labelIds: d["labelIds"] as? [String] ?? [],
            tagIds: d["tagIds"] as? [String] ?? [],
            number: d["number"] as? Int,
            startDate: DateParsing.date(from: d["startDate"]),
            targetDate: DateParsing.date(from: d["targetDate"]),
            createdAt: DateParsing.date(from: d["createdAt"]) ?? Date(),
            updatedAt: DateParsing.date(from: d["updatedAt"]),
            status: status,
            assignee: assignee
        )
    }
}
