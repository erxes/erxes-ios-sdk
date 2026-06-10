import SwiftUI
import SafariServices

// Makes URL usable with .sheet(item:)
extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    var backgroundColor: UIColor = .black

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        let vc = SFSafariViewController(url: url, configuration: config)
        // Apply background immediately so there's no white flash while the page loads
        vc.view.backgroundColor = backgroundColor
        return vc
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
