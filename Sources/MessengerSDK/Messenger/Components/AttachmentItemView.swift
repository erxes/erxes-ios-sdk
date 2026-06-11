import SwiftUI

/// Renders a single message attachment: an inline image for image types,
/// or a tappable file chip (opens in Safari) for everything else.
struct AttachmentItemView: View {
    let attachment: Attachment
    let fileEndpoint: String
    /// Tint used for the file-chip styling on the customer (sent) side.
    var isFromCustomer: Bool = false

    /// The URL currently presented in the in-app browser. Driving the sheet by
    /// `item:` (rather than a bool) is more reliable for dynamically-built rows.
    @State private var presentedURL: URL?

    private var url: URL? {
        AttachmentURL.resolve(attachment.url, fileEndpoint: fileEndpoint)
    }

    /// Image when the API type says so, or when the URL/name has an image extension.
    private var isImage: Bool {
        if attachment.type.lowercased().contains("image") { return true }
        let probe = (attachment.name ?? attachment.url).lowercased()
        return ["png", "jpg", "jpeg", "gif", "webp", "heic", "bmp"]
            .contains { probe.hasSuffix(".\($0)") }
    }

    var body: some View {
        Group {
            if isImage {
                imageView
            } else {
                fileChip
            }
        }
        // One sheet for the whole item, opened by tapping the image or file chip.
        .sheet(item: $presentedURL) { SafariView(url: $0) }
    }

    // MARK: - Image

    private var imageView: some View {
        // A definite frame is required: a `resizable` image has no intrinsic size,
        // so a flexible `maxWidth/maxHeight` frame collapses to 0pt height and the
        // image never appears (avatars work because they use a fixed frame).
        CachedAsyncImage(url: url, maxPixel: 600) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 220, height: 220)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture { presentedURL = url }
    }

    // MARK: - Non-image file

    private var fileChip: some View {
        Button {
            presentedURL = url
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "doc.fill")
                    .font(.subheadline)
                Text(attachment.name ?? "Attachment")
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(isFromCustomer ? Color.white : Color.primary)
            .background(
                isFromCustomer ? AnyShapeStyle(Color.white.opacity(0.2))
                               : AnyShapeStyle(Color.gray.opacity(0.15)),
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
        }
        .buttonStyle(.plain)
    }
}
