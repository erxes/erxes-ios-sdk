import SwiftUI

/// requireAuth identity-capture form. Shown before a new conversation when the
/// integration requires the visitor to provide an email or phone number.
/// On success it calls `appVM.identify(...)` and invokes `onAuthenticated`.
struct GetNotifiedView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss

    /// When true the view renders without its own full-screen background, so it
    /// can be embedded inline (e.g. as a card inside the Messages tab) rather
    /// than presented as a sheet.
    var embedded: Bool = false

    /// Called once the contact has been saved successfully.
    let onAuthenticated: () -> Void

    @State private var kind: AppViewModel.ContactKind = .email
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var contact = ""
    @State private var isSaving = false
    @State private var error: String?

    private var primary: Color { Color(appVM.effectivePrimaryColor) }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("ENTER YOUR EMAIL OR PHONE NUMBER")
                .font(.footnote.weight(.bold))
                .tracking(0.5)
                .foregroundStyle(.primary)

            segmentedPicker

            VStack(spacing: 12) {
                field("First name", text: $firstName)
                field("Last name", text: $lastName)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(kind == .email ? "EMAIL" : "PHONE")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                field(
                    kind == .email ? "Email" : "Phone",
                    text: $contact,
                    keyboard: kind == .email ? .emailAddress : .phonePad
                )
            }

            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            saveButton
        }
        .padding(20)
        .background {
            // Inline (embedded) use is wrapped in a card by the host, so it
            // must not paint a full-screen background of its own.
            if !embedded {
                Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea()
            }
        }
        .environment(\.colorScheme, appVM.effectiveColorScheme)
        .tint(primary)
    }

    // MARK: - Subviews

    private var segmentedPicker: some View {
        HStack(spacing: 24) {
            ForEach([AppViewModel.ContactKind.email, .phone], id: \.self) { option in
                let isActive = kind == option
                Button {
                    withAnimation(.easeOut(duration: 0.15)) { kind = option }
                    contact = ""
                    error = nil
                } label: {
                    VStack(spacing: 6) {
                        Text(option == .email ? "Email" : "Phone")
                            .font(.subheadline.weight(isActive ? .semibold : .regular))
                            .foregroundStyle(isActive ? .primary : .secondary)
                        Rectangle()
                            .fill(isActive ? primary : .clear)
                            .frame(height: 2)
                    }
                    .fixedSize()
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }

    private func field(
        _ placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        TextField(placeholder, text: text)
            .font(.subheadline)
            .keyboardType(keyboard)
            .textInputAutocapitalization(keyboard == .emailAddress ? .never : .words)
            .autocorrectionDisabled(keyboard == .emailAddress)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.10), lineWidth: 1)
            )
    }

    private var saveButton: some View {
        Button {
            Task { await save() }
        } label: {
            ZStack {
                if isSaving {
                    ProgressView().tint(.primary)
                } else {
                    Text("Save").font(.subheadline.weight(.semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(primary.opacity(0.8), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(isSaving)
        .padding(.top, 4)
    }

    // MARK: - Save

    private func save() async {
        let value = contact.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValid(value) else {
            error = kind == .email ? "Please enter a valid email." : "Please enter a valid phone number."
            return
        }
        error = nil
        isSaving = true
        do {
            try await appVM.identify(
                kind: kind,
                value: value,
                firstName: firstName.trimmingCharacters(in: .whitespaces),
                lastName: lastName.trimmingCharacters(in: .whitespaces)
            )
            isSaving = false
            onAuthenticated()
        } catch {
            isSaving = false
            self.error = error.localizedDescription
        }
    }

    private func isValid(_ value: String) -> Bool {
        guard !value.isEmpty else { return false }
        switch kind {
        case .email:
            return value.contains("@") && value.contains(".")
        case .phone:
            return value.filter(\.isNumber).count >= 6
        }
    }
}
