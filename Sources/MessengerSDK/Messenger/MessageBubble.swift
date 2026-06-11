import SwiftUI

struct MessageBubble: View {
    let message: Message
    let primaryColor: UIColor
    var isFirstInGroup: Bool = true
    var isLastInGroup: Bool = true

    @EnvironmentObject private var appVM: AppViewModel

    private var isBot: Bool { message.fromBot == true }
    private var primary: Color { Color(primaryColor) }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromCustomer {
                Spacer(minLength: 56)
            }

            // Left avatar (agent / bot)
            if !message.isFromCustomer {
                Group {
                    if isLastInGroup {
                        agentAvatar
                    } else {
                        Color.clear.frame(width: 32)
                    }
                }
            }

            // Bubble + labels
            VStack(alignment: message.isFromCustomer ? .trailing : .leading, spacing: 4) {
                // Sender label (first in group, agent only)
                if !message.isFromCustomer && isFirstInGroup {
                    senderLabel
                }

                bubbleContent
            }

            if !message.isFromCustomer {
                Spacer(minLength: 56)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, isFirstInGroup ? 3 : 1)
    }

    // MARK: - Sender label

    @ViewBuilder
    private var senderLabel: some View {
        HStack(spacing: 5) {
            Text(senderName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)

            if isBot {
                Text("AI")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(primary, in: Capsule())
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Agent avatar

    @ViewBuilder
    private var agentAvatar: some View {
        if isBot {
            // Purple sparkles square — AI agent
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.48, green: 0.25, blue: 0.90),
                                 Color(red: 0.28, green: 0.10, blue: 0.70)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                )
        } else {
            AvatarWithStatusView(
                avatarKey: message.user?.details?.avatar,
                isOnline: false,
                size: 32
            )
        }
    }

    // MARK: - Bubble

    private var hasText: Bool {
        !message.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @ViewBuilder
    private var bubbleContent: some View {
        VStack(alignment: message.isFromCustomer ? .trailing : .leading, spacing: 6) {
            // Text bubble — skipped for attachment-only messages so we don't show an
            // empty pill.
            if hasText {
                textBubble
            }

            // Attachments
            if !message.attachments.isEmpty {
                ForEach(message.attachments) { attachment in
                    AttachmentItemView(
                        attachment: attachment,
                        fileEndpoint: appVM.config?.fileEndpoint ?? "",
                        isFromCustomer: message.isFromCustomer
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var textBubble: some View {
        if message.isFromCustomer {
            MessageContentView(content: message.content, isFromCustomer: true)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(primary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .foregroundStyle(.white)
        } else {
            MessageContentView(content: message.content, isFromCustomer: false)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .liquidGlass(
                    shape: RoundedRectangle(cornerRadius: 18, style: .continuous),
                    shadowRadius: 2
                )
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Helpers

    private var senderName: String {
        if isBot { return "Ai Agent" }
        return message.user?.details?.displayName ?? "Support"
    }

}
