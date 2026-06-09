import SwiftUI

/// Rendered at the top of a new conversation showing the automated greeting.
/// Mirrors RN SDK's WelcomeMessage component.
struct WelcomeMessageView: View {
    let message: String
    let primaryColor: UIColor

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Bot avatar
            Circle()
                .fill(Color(primaryColor).opacity(0.15))
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(primaryColor))
                }

            Text(message)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 18))
                .frame(maxWidth: .infinity * 0.8, alignment: .leading)

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
