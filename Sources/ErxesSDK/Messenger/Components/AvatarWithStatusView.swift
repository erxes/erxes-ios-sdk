import SwiftUI

struct AvatarWithStatusView: View {
    let avatarKey: String?   // raw key from API e.g. "office-erxes-io/photo.png"
    let isOnline: Bool
    let size: CGFloat

    @EnvironmentObject private var appVM: AppViewModel

    init(avatarKey: String? = nil, isOnline: Bool = false, size: CGFloat = 36) {
        self.avatarKey = avatarKey
        self.isOnline = isOnline
        self.size = size
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarImage
                .frame(width: size, height: size)
                .background(Color(.systemGray5))
                .clipShape(Circle())

            if isOnline {
                Circle()
                    .fill(Color.green)
                    .frame(width: size * 0.28, height: size * 0.28)
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 1.5))
            }
        }
    }

    @ViewBuilder
    private var avatarImage: some View {
        if let url = resolvedURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholder
                case .empty:
                    Color(.systemGray5)
                        .overlay(ProgressView().scaleEffect(0.6))
                @unknown default:
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(size * 0.22)
            .foregroundStyle(.secondary)
    }

    private var resolvedURL: URL? {
        guard let key = avatarKey, !key.isEmpty else { return nil }
        guard let fileEndpoint = appVM.config?.fileEndpoint, !fileEndpoint.isEmpty else { return nil }
        return AttachmentURL.resolve(key, fileEndpoint: fileEndpoint)
    }
}
