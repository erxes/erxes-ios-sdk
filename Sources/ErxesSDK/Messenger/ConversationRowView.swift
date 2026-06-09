import SwiftUI

struct ConversationRowView: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 14) {
            // Initial avatar
            Text(initial)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray3), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(displayName)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                    Spacer()
                    Text(timeAgo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let content = conversation.content, !content.isEmpty {
                    Text(content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    // MARK: - Helpers

    private var displayName: String {
        conversation.messages.first?.isFromCustomer == false
            ? "Support"
            : "You"
    }

    private var initial: String {
        String(displayName.prefix(1)).uppercased()
    }

    private var timeAgo: String {
        let diff = Date().timeIntervalSince(conversation.createdAt)
        switch diff {
        case ..<60:              return "just now"
        case ..<3_600:           return "\(Int(diff / 60))m ago"
        case ..<86_400:          return "\(Int(diff / 3_600))h ago"
        case ..<(86_400 * 7):   return "\(Int(diff / 86_400)) days ago"
        default:
            let f = DateFormatter(); f.dateStyle = .medium; f.timeStyle = .none
            return f.string(from: conversation.createdAt)
        }
    }
}
