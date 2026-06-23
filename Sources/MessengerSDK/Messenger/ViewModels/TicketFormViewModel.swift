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
        var variables: [String: Any] = ["configId": configId]
        if let pid = parentId { variables["parentId"] = pid }

        guard let list = try? await GraphQL.array(
            endpoint: endpoint,
            operation: "widgetsGetTicketTags",
            query: MessengerGraphQL.ticketTags,
            variables: variables,
            field: "widgetsGetTicketTags"
        ) else { return [] }

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
