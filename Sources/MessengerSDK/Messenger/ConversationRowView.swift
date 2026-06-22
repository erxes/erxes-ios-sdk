import SwiftUI

struct ConversationRowView: View {
    @EnvironmentObject var appVM: AppViewModel
    let conversation: Conversation

    private var isBot: Bool { conversation.lastMessage?.fromBot == true }

    var body: some View {
        HStack(spacing: 14) {
            // ── Avatar ────────────────────────────────────────────────────────
            avatarView
                .frame(width: 44, height: 44)

            // ── Text content ──────────────────────────────────────────────────
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

                Text(previewText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                // Bot badge
                if isBot {
                    botBadge
                }
            }

        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    // MARK: - Bot badge

    private var botBadge: some View {
        let primary = Color(appVM.effectivePrimaryColor)
        return HStack(spacing: 4) {
            Image(systemName: "circle.dotted")
                .font(.system(size: 11, weight: .medium))
            Text("AI Agent · Automated")
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(primary)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(primary.opacity(0.12), in: Capsule())
    }

    // MARK: - Avatar

    @ViewBuilder
    private var avatarView: some View {
        if isBot {
            botAvatar
        } else if let avatarKey = firstParticipant?.details?.avatar,
                  !avatarKey.isEmpty,
                  let base = appVM.config?.fileEndpoint,
                  let url = AttachmentURL.resolve(avatarKey, fileEndpoint: base) {
            CachedAsyncImage(url: url, maxPixel: 44) { img in
                img.resizable().scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            } placeholder: {
                initialsAvatar
            }
        } else {
            initialsAvatar
        }
    }

    /// Purple rounded-square with sparkles icon — matches AI agent branding.
    private var botAvatar: some View {
        let primary = Color(appVM.effectivePrimaryColor)
        return Image(systemName: "sparkles")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 44, height: 44)
            .background(
                LinearGradient(
                    colors: [primary, primary.opacity(0.70)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
    }

    private var initialsAvatar: some View {
        Text(initials)
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: 44, height: 44)
            .background(Color(appVM.effectivePrimaryColor).opacity(0.75),
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - Helpers

    private var firstParticipant: ParticipatedUser? {
        conversation.participatedUsers.first
    }

    private var displayName: String {
        if isBot { return "AI Agent" }
        return firstParticipant?.details?.displayName ?? "Support"
    }

    private var initials: String {
        let words = displayName.split(separator: " ")
        if words.count >= 2 {
            return "\(words[0].prefix(1))\(words[1].prefix(1))".uppercased()
        }
        return String(displayName.prefix(2)).uppercased()
    }

    private var previewText: String {
        if let last = conversation.lastMessage {
            if !last.attachments.isEmpty { return "📎 \(last.attachments.first?.name ?? "Attachment")" }
            let plain = MessageContentView.plainText(from: last.content)
            return plain.isEmpty ? "…" : plain
        }
        let fallback = conversation.content ?? ""
        let plain = MessageContentView.plainText(from: fallback)
        return plain.isEmpty ? "No messages yet" : plain
    }

    private var timeAgo: String {
        let ref = conversation.lastMessage?.createdAt ?? conversation.createdAt
        let diff = Date().timeIntervalSince(ref)
        switch diff {
        case ..<60:            return "just now"
        case ..<3_600:         return "\(Int(diff / 60))m ago"
        case ..<86_400:        return "\(Int(diff / 3_600))h ago"
        case ..<(86_400 * 7): return "\(Int(diff / 86_400))d ago"
        default:               return Self.dateFmt.string(from: ref)
        }
    }

    private static let dateFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
}
