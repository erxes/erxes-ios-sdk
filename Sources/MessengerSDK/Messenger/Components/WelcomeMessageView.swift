import SwiftUI

/// Rendered at the top of a new conversation showing the automated greeting.
/// Mirrors RN SDK's WelcomeMessage component.
struct WelcomeMessageView: View {
    let message: String
    let primaryColor: UIColor

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Bot avatar
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.48, green: 0.25, blue: 0.90),
                                 Color(red: 0.28, green: 0.10, blue: 0.70)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .overlay {
                    Image("bot", bundle: .messengerSDKResources)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
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
