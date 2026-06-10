import Foundation

@MainActor
final class TicketFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var selectedTagIds: Set<String> = []
    @Published var availableTags: [TicketTag] = []
    @Published var isLoadingTags = false
    @Published var isSubmitting = false
    @Published var submitError: String?
    @Published var didSubmit = false

    // MARK: - Load tags

    func loadTags(config: TicketConfig, endpoint: String) {
        guard config.formFields.tags?.isShow == true else { return }
        isLoadingTags = true
        Task {
            availableTags = await fetchTags(
                configId: config.id,
                parentId: config.parentId,
                endpoint: endpoint
            )
            isLoadingTags = false
        }
    }

    private func fetchTags(configId: String, parentId: String?, endpoint: String) async -> [TicketTag] {
        let base = endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else { return [] }

        let query = """
        query WidgetsGetTicketTags($configId: String, $parentId: String) {
          widgetsGetTicketTags(configId: $configId, parentId: $parentId) {
            _id
            name
            type
            description
          }
        }
        """
        var variables: [String: Any] = ["configId": configId]
        if let pid = parentId { variables["parentId"] = pid }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let body = try? JSONSerialization.data(withJSONObject: ["query": query, "variables": variables]) else { return [] }
        request.httpBody = body

        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let list = (json["data"] as? [String: Any])?["widgetsGetTicketTags"] as? [[String: Any]] else {
            return []
        }

        return list.compactMap { t in
            guard let id = t["_id"] as? String, let name = t["name"] as? String else { return nil }
            return TicketTag(id: id, name: name, type: t["type"] as? String, description: t["description"] as? String)
        }
    }

    // MARK: - Submit

    func submit(appVM: AppViewModel, ticketConfig: TicketConfig, onSuccess: @escaping () -> Void) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            submitError = "Please enter a subject."
            return
        }
        guard let config = appVM.config else { return }

        isSubmitting = true
        submitError = nil

        Task {
            do {
                var customerIds: [String] = []
                if let cid = appVM.customerId { customerIds = [cid] }

                let ticket = try await TicketMutations.createTicket(
                    config: config,
                    name: name.trimmingCharacters(in: .whitespaces),
                    statusId: ticketConfig.selectedStatusId,
                    customerIds: customerIds,
                    description: description.trimmingCharacters(in: .whitespaces).isEmpty
                        ? nil
                        : description.trimmingCharacters(in: .whitespaces),
                    tagIds: selectedTagIds.isEmpty ? nil : Array(selectedTagIds)
                )
                SDKLogger.debug("Ticket created: \(ticket.id)")
                didSubmit = true
                onSuccess()
            } catch {
                submitError = error.localizedDescription
            }
            isSubmitting = false
        }
    }
}
