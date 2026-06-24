import SwiftUI

struct ConversationRowView: View {
    @EnvironmentObject var appVM: AppViewModel
    let conversation: Conversation
    var compact: Bool = false

    private var isBot: Bool { conversation.lastMessage?.fromBot == true }
    /// True when the most recent message was sent by the customer (me).
    private var lastFromMe: Bool { conversation.lastMessage?.isFromCustomer == true }
    private var avatarSize: CGFloat { compact ? 32 : 44 }
    private var avatarCornerRadius: CGFloat { compact ? 10 : 14 }

    var body: some View {
        HStack(spacing: compact ? 10 : 14) {
            // ── Avatar ────────────────────────────────────────────────────────
            avatarView
                .frame(width: avatarSize, height: avatarSize)

            // ── Text content ──────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 6) {
                    Text(displayName)
                        .font(compact ? .system(size: 15, weight: .medium) : .subheadline.weight(.semibold))
                        .lineLimit(1)
                    // Combined "AI Bot · Automated" badge next to the title.
                    if isBot {
                        botBadge
                    }
                    Spacer()
                    Text(timeAgo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(previewText)
                    .font(compact ? .caption : .subheadline)
                    .foregroundStyle(.secondary)
                    // Dim the preview when the last message is one I sent — it's
                    // awaiting a reply, so it reads as less prominent than an
                    // incoming message.
                    .opacity(lastFromMe ? 0.5 : 1)
                    .lineLimit(1)
            }

        }
        .padding(.horizontal, compact ? 12 : 14)
        .padding(.vertical, compact ? 8 : 14)
        .contentShape(Rectangle())
    }

    // MARK: - Bot badge

    /// Combined "AI Bot · Automated" pill shown next to the title.
    private var botBadge: some View {
        let primary = Color(appVM.effectivePrimaryColor)
        return HStack(spacing: 4) {
            Image(systemName: "circle.dotted")
                .font(.system(size: 10, weight: .medium))
            Text("AI Bot · Automated")
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(primary)
        .padding(.horizontal, 7)
        .padding(.vertical, 2)
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
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(RoundedRectangle(cornerRadius: avatarCornerRadius, style: .continuous))
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
            .font(.system(size: compact ? 15 : 20, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: avatarSize, height: avatarSize)
            .background(
                LinearGradient(
                    colors: [primary, primary.opacity(0.70)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: avatarCornerRadius, style: .continuous)
            )
    }

    private var initialsAvatar: some View {
        Text(initials)
            .font(compact ? .subheadline.weight(.semibold) : .headline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: avatarSize, height: avatarSize)
            .background(Color(appVM.effectivePrimaryColor).opacity(0.75),
                        in: RoundedRectangle(cornerRadius: avatarCornerRadius, style: .continuous))
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
        let day = 86_400.0
        switch diff {
        case ..<60:           return "just now"
        case ..<3_600:        return "\(Int(diff / 60))m ago"
        case ..<day:          return "\(Int(diff / 3_600))h ago"
        case ..<(day * 30):   return "\(Int(diff / day))d ago"
        case ..<(day * 365):  return "\(Int(diff / (day * 30)))mo ago"
        // Older than a year — relative loses meaning, show the full date.
        default:              return Self.dateFmt.string(from: ref)
        }
    }

    private static let dateFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
}
