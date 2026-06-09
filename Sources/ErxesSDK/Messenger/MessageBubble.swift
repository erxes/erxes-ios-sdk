import SwiftUI

struct MessageBubble: View {
    let message: Message
    let primaryColor: UIColor

    var body: some View {
        HStack {
            if message.isFromCustomer { Spacer(minLength: 60) }

            VStack(alignment: message.isFromCustomer ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromCustomer
                            ? Color(primaryColor)
                            : Color(.systemGray5),
                        in: RoundedRectangle(cornerRadius: 18)
                    )
                    .foregroundStyle(message.isFromCustomer ? .white : .primary)

                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if !message.isFromCustomer { Spacer(minLength: 60) }
        }
    }
}
