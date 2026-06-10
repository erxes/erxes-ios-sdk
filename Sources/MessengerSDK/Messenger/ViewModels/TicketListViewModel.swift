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
        let base = config.fileEndpoint.hasSuffix("/")
            ? String(config.fileEndpoint.dropLast())
            : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else { throw URLError(.badURL) }

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

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query": query,
            "variables": variables
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        SDKLogger.debug("widgetTicketsByCustomer HTTP \(statusCode)")

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        if let errs = json["errors"] as? [[String: Any]] {
            SDKLogger.error("widgetTicketsByCustomer errors: \(errs)")
        }

        guard let list = (json["data"] as? [String: Any])?["widgetTicketsByCustomer"] as? [[String: Any]] else {
            return []
        }

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
            startDate: parseDate(d["startDate"]),
            targetDate: parseDate(d["targetDate"]),
            createdAt: parseDate(d["createdAt"]) ?? Date(),
            updatedAt: parseDate(d["updatedAt"]),
            status: status,
            assignee: assignee
        )
    }

    private func parseDate(_ value: Any?) -> Date? {
        if let ms = value as? Double { return Date(timeIntervalSince1970: ms / 1_000) }
        if let ms = value as? Int    { return Date(timeIntervalSince1970: Double(ms) / 1_000) }
        if let str = value as? String {
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = f.date(from: str) { return d }
            f.formatOptions = [.withInternetDateTime]
            return f.date(from: str)
        }
        return nil
    }
}
