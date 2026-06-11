import SwiftUI
import WebKit

/// Spins up a WKWebView's web-content process ahead of time so the first real
/// article load doesn't pay the cold-start cost during the navigation push (that
/// cold start is what makes opening an article feel laggy). Holds one hidden web
/// view alive so the running content process is reused by subsequent web views.
@MainActor
final class WebViewWarmer {
    static let shared = WebViewWarmer()
    private var warmView: WKWebView?

    func warm() {
        guard warmView == nil else { return }
        let wv = WKWebView(frame: .zero)
        wv.loadHTMLString("<html><body></body></html>", baseURL: nil)
        warmView = wv
    }
}

/// Renders knowledge base article HTML with a themed stylesheet so it matches
/// the SDK's background / text / accent colors instead of a bare white page.
struct HTMLContentView: UIViewRepresentable {
    let html: String
    let textColor: UIColor
    let backgroundColor: UIColor
    let tint: UIColor

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        // Load immediately at creation so the content is ready as the push settles.
        context.coordinator.loadedHTML = html
        webView.loadHTMLString(styledDocument, baseURL: nil)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if context.coordinator.loadedHTML != html {
            context.coordinator.loadedHTML = html
            webView.loadHTMLString(styledDocument, baseURL: nil)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    /// Opens tapped links in the system browser instead of navigating the article away.
    final class Coordinator: NSObject, WKNavigationDelegate {
        var loadedHTML: String?

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated,
               let url = navigationAction.request.url {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }

    // MARK: - Styled document

    private var styledDocument: String {
        let text = textColor.hexString
        let bg = backgroundColor.hexString
        let accent = tint.hexString
        let secondary = textColor.withAlphaComponent(0.6).hexString
        return """
        <!doctype html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <style>
          :root { color-scheme: light dark; }
          html, body {
            margin: 0; padding: 0;
            background-color: \(bg);
            color: \(text);
          }
          body {
            font: -apple-system-body;
            font-family: -apple-system, system-ui, sans-serif;
            font-size: 17px;
            line-height: 1.6;
            padding: 16px 20px 60px;
            -webkit-text-size-adjust: 100%;
            word-wrap: break-word;
          }
          /* Force the SDK's UI text color, overriding inline colors authored for a
             white page so content stays readable on the SDK background. */
          body, p, span, div, li, ul, ol, h1, h2, h3, h4, h5, h6,
          td, th, strong, em, b, i, small, label, figcaption {
            color: \(text) !important;
          }
          h1, h2, h3, h4 { line-height: 1.3; }
          a, a span { color: \(accent) !important; text-decoration: none; }
          img, video, iframe { max-width: 100%; height: auto; border-radius: 12px; }
          pre, code {
            font-family: ui-monospace, Menlo, monospace;
            background: \(secondary)1a;
            border-radius: 8px;
          }
          pre { padding: 12px; overflow-x: auto; }
          code { padding: 2px 5px; }
          blockquote {
            margin: 0; padding-left: 16px;
            border-left: 3px solid \(accent);
            color: \(secondary);
          }
          table { border-collapse: collapse; width: 100%; }
          td, th { border: 1px solid \(secondary)40; padding: 8px; }
          hr { border: none; border-top: 1px solid \(secondary)40; }
        </style>
        </head>
        <body>\(html)</body>
        </html>
        """
    }
}

// MARK: - UIColor → hex helper

extension UIColor {
    /// `#RRGGBB` hex string for use in injected CSS.
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let ri = Int(round(max(0, min(1, r)) * 255))
        let gi = Int(round(max(0, min(1, g)) * 255))
        let bi = Int(round(max(0, min(1, b)) * 255))
        return String(format: "#%02X%02X%02X", ri, gi, bi)
    }
}
