import SwiftUI

struct ConversationRowView: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.secondary.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Support")
                        .font(.headline)
                    Spacer()
                    Text(conversation.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let content = conversation.content {
                    Text(content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            if conversation.unreadCount > 0 {
                Text("\(conversation.unreadCount)")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(Color.accentColor, in: Circle())
            }
        }
        .padding(.vertical, 4)
    }
}
