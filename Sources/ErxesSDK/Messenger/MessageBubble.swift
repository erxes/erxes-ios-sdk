import SwiftUI

struct MessageBubble: View {
    let message: Message
    let primaryColor: UIColor
    var isFirstInGroup: Bool = true
    var isLastInGroup: Bool = true

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            if message.isFromCustomer { Spacer(minLength: 60) }

            // Agent avatar on last in group
            if !message.isFromCustomer {
                Group {
                    if isLastInGroup {
                        AvatarWithStatusView(size: 28)
                    } else {
                        Color.clear.frame(width: 28)
                    }
                }
            }

            VStack(alignment: message.isFromCustomer ? .trailing : .leading, spacing: 2) {
                if !message.isFromCustomer && isFirstInGroup {
                    Text("Support")
                        .font(.caption2).foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }

                messageBubble

                if isLastInGroup {
                    Text(message.createdAt, style: .time)
                        .font(.caption2).foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
            }

            if !message.isFromCustomer { Spacer(minLength: 60) }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, isFirstInGroup ? 2 : 1)
    }

    @ViewBuilder
    private var messageBubble: some View {
        if message.isFromCustomer {
            // Customer: solid brand color
            Text(message.content)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(primaryColor), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .foregroundStyle(.white)
        } else {
            // Agent: Liquid Glass on iOS 26, material on older
            Text(message.content)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .liquidGlass(
                    shape: RoundedRectangle(cornerRadius: 18, style: .continuous),
                    shadowRadius: 2
                )
                .foregroundStyle(.primary)
        }
    }
}
