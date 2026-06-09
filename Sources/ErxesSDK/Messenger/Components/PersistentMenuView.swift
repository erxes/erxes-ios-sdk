import SwiftUI

/// Quick-reply menu shown above the composer for bot flows.
/// Mirrors RN SDK's PersistentMenu component.
public struct PersistentMenuItem {
    public let text: String
    public let type: String?   // "link" | nil (button)
    public let link: String?
}

struct PersistentMenuView: View {
    let items: [PersistentMenuItem]
    let onSendText: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if index > 0 { Divider() }
                Button {
                    if item.type == "link", let link = item.link, let url = URL(string: link) {
                        UIApplication.shared.open(url)
                    } else {
                        onSendText(item.text)
                    }
                } label: {
                    Text(item.text)
                        .font(.subheadline)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                .foregroundStyle(.primary)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
    }
}
