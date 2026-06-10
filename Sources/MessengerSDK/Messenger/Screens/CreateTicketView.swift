import SwiftUI

struct CreateTicketView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var formVM = TicketFormViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showTagPicker = false

    /// nil = no ticketConfig returned by server → show default subject+description form
    let ticketConfig: TicketConfig?
    var onCreated: (() -> Void)? = nil

    // Visible fields sorted by order; falls back to a sensible default set
    private var visibleFields: [(key: String, config: TicketFieldConfig)] {
        if let cfg = ticketConfig {
            return cfg.formFields.visibleFields
        }
        // Default: subject (order 1) + description (order 2)
        return [
            ("name",        TicketFieldConfig(isShow: true, label: nil, placeholder: nil, order: 1)),
            ("description", TicketFieldConfig(isShow: true, label: nil, placeholder: nil, order: 2)),
        ]
    }

    private var sheetTitle: String {
        if let name = ticketConfig?.name, !name.isEmpty { return name }
        return "Create Ticket"
    }

    var body: some View {
        let primary = Color(appVM.effectivePrimaryColor)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(visibleFields, id: \.key) { key, config in
                        fieldView(key: key, config: config, primary: primary)
                    }

                    if let err = formVM.submitError {
                        Text(err)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    submitButton(primary: primary)
                }
                .padding(20)
            }
            .scrollContentBackground(.hidden)
            .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .onAppear {
            if let config = ticketConfig,
               let endpoint = appVM.config?.fileEndpoint {
                formVM.loadTags(config: config, endpoint: endpoint)
            }
        }
    }

    // MARK: - Submit button

    private func submitButton(primary: Color) -> some View {
        Button {
            if let config = ticketConfig {
                formVM.submit(appVM: appVM, ticketConfig: config) {
                    onCreated?()   // refetch before sheet animation completes
                    dismiss()
                }
            } else {
                // No ticketConfig — still validate locally; real submit needs statusId
                formVM.submitError = "Ticket configuration not loaded yet. Please try again."
            }
        } label: {
            Group {
                if formVM.isSubmitting {
                    ProgressView().tint(.white)
                } else {
                    Text("Submit ticket")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.white)
            .background(primary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(formVM.isSubmitting)
        .padding(.top, 4)
    }

    // MARK: - Field dispatcher

    @ViewBuilder
    private func fieldView(key: String, config: TicketFieldConfig, primary: Color) -> some View {
        switch key {
        case "name":        nameField(config: config)
        case "description": descriptionField(config: config)
        case "tags":        tagsField(config: config, primary: primary)
        default:            EmptyView()
        }
    }

    // MARK: - Name

    private func nameField(config: TicketFieldConfig) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(config.label ?? "Name")
                .font(.subheadline.weight(.semibold))
            TextField(config.placeholder ?? "Enter name…", text: $formVM.name)
                .padding(12)
                .background(Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Description

    private func descriptionField(config: TicketFieldConfig) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(config.label ?? "Description")
                .font(.subheadline.weight(.semibold))
            TextField(config.placeholder ?? "Describe your issue…",
                      text: $formVM.description,
                      axis: .vertical)
                .lineLimit(4...8)
                .padding(12)
                .background(Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Tags

    private func tagsField(config: TicketFieldConfig, primary: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(config.label ?? "Tags")
                .font(.subheadline.weight(.semibold))

            if formVM.isLoadingTags {
                HStack(spacing: 8) {
                    ProgressView().scaleEffect(0.8)
                    Text("Loading tags…").font(.subheadline).foregroundStyle(.secondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                // Trigger button
                Button { showTagPicker = true } label: {
                    HStack {
                        if formVM.selectedTagIds.isEmpty {
                            Text("Select tags…")
                                .foregroundStyle(.secondary)
                        } else {
                            let names = formVM.availableTags
                                .filter { formVM.selectedTagIds.contains($0.id) }
                                .map(\.name)
                                .joined(separator: ", ")
                            Text(names)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.secondarySystemBackground),
                                in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showTagPicker) {
                    TagMultiPickerView(
                        tags: formVM.availableTags,
                        selected: $formVM.selectedTagIds,
                        primary: primary,
                        backgroundColor: Color(appVM.effectiveContainerBackgroundColor)
                    )
                    .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

