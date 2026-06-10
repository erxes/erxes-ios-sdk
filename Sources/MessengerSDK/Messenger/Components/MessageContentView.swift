import SwiftUI

/// Renders message content (BlockNote JSON, HTML, or plain text).
/// Parsing is synchronous and fast — no WebKit, no NSAttributedString HTML renderer.
/// All results are cached so each unique string is parsed exactly once.
struct MessageContentView: View {
    let content: String
    let isFromCustomer: Bool

    var body: some View {
        Text(ContentParser.parse(content))
            .font(.subheadline)
            .tint(isFromCustomer ? .white : .accentColor)
    }

    // MARK: - Plain text preview (for list rows)

    static func plainText(from content: String) -> String {
        ContentParser.toPlainText(content)
    }
}

// MARK: - ContentParser

enum ContentParser {

    // MARK: - Static resources (created once for the lifetime of the app)

    /// Shared decoder — JSONDecoder construction is not free.
    private static let decoder = JSONDecoder()

    /// Link / URL detector — expensive to create, so we keep one instance.
    private static let linkDetector: NSDataDetector? = try? NSDataDetector(
        types: NSTextCheckingResult.CheckingType.link.rawValue
    )

    // MARK: - Thread-safe result caches

    private final class AttrBox: NSObject {
        let value: AttributedString
        init(_ v: AttributedString) { value = v }
    }

    private final class TextBox: NSObject {
        let value: String
        init(_ v: String) { value = v }
    }

    /// `NSCache` is thread-safe and evicts automatically under memory pressure.
    private static let attrCache = NSCache<NSString, AttrBox>()
    private static let textCache = NSCache<NSString, TextBox>()

    // MARK: - Entry point

    /// Returns a cached `AttributedString` for `raw`. Safe to call from any thread.
    static func parse(_ raw: String) -> AttributedString {
        let key = raw as NSString
        if let hit = attrCache.object(forKey: key) { return hit.value }

        let result = applyLinks(toPlainText(raw))
        attrCache.setObject(AttrBox(result), forKey: key)
        return result
    }

    /// Returns a cached plain-text version for list row previews. Safe to call from any thread.
    static func toPlainText(_ raw: String) -> String {
        let key = raw as NSString
        if let hit = textCache.object(forKey: key) { return hit.value }

        let s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let result: String

        if s.hasPrefix("["),
           let data = s.data(using: .utf8),
           let blocks = try? decoder.decode([BNBlock].self, from: data) {
            // BlockNote JSON — flatten all inline text nodes
            result = blocks
                .map { extractText(from: $0) }
                .filter { !$0.isEmpty }
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)

        } else if s.contains("<") {
            // HTML — strip tags, keep newlines at block boundaries
            result = stripHTML(s)

        } else {
            result = s
        }

        textCache.setObject(TextBox(result), forKey: key)
        return result
    }

    // MARK: - Cache warm-up

    /// Pre-parses a batch of content strings on a background thread so the first
    /// SwiftUI render already hits the cache. Call right after loading messages.
    static func warmCache(contents: [String]) {
        Task.detached(priority: .utility) {
            for raw in contents {
                _ = parse(raw)
                _ = toPlainText(raw)
            }
        }
    }

    // MARK: - HTML → plain text

    /// Strips all HTML tags and decodes entities.
    /// Block-level closing tags become newlines; `<br>` becomes a newline.
    private static func stripHTML(_ html: String) -> String {
        html
            // Block endings → newline
            .replacingOccurrences(
                of: #"</(p|div|li|blockquote|h[1-6]|tr|td|th)>"#,
                with: "\n",
                options: .regularExpression
            )
            // <br> variants → newline
            .replacingOccurrences(of: #"<br\s*/?>"#, with: "\n", options: .regularExpression)
            // Strip all remaining tags
            .replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
            .htmlEntitiesDecoded
            // Collapse runs of blank lines to a single blank line
            .replacingOccurrences(of: #"\n{3,}"#, with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - BlockNote → plain text

    private static func extractText(from block: BNBlock) -> String {
        var parts: [String] = []

        if let inlines = block.content {
            let line = inlines.map { inlineText($0) }.joined()
            if !line.isEmpty { parts.append(line) }
        }

        for child in block.children ?? [] {
            let sub = extractText(from: child)
            if !sub.isEmpty { parts.append(sub) }
        }

        return parts.joined(separator: "\n")
    }

    private static func inlineText(_ inline: BNInline) -> String {
        switch inline.type {
        case "text":
            return inline.text ?? ""
        case "link":
            // Prefer visible label text; fall back to the URL itself
            let label = inline.content?.map { inlineText($0) }.joined() ?? ""
            return label.isEmpty ? (inline.href ?? "") : label
        default:
            return inline.content?.map { inlineText($0) }.joined() ?? inline.text ?? ""
        }
    }

    // MARK: - Link detection

    /// Scans `text` for URLs / email addresses and wraps them in `.link` attributes.
    private static func applyLinks(_ text: String) -> AttributedString {
        guard let detector = linkDetector else { return AttributedString(text) }

        let ns = text as NSString
        let matches = detector.matches(in: text, range: NSRange(location: 0, length: ns.length))

        guard !matches.isEmpty else { return AttributedString(text) }

        var result = AttributedString()
        var cursor = text.startIndex

        for match in matches {
            guard let range = Range(match.range, in: text), let url = match.url else { continue }

            // Plain text before this link
            if cursor < range.lowerBound {
                result += AttributedString(String(text[cursor..<range.lowerBound]))
            }

            // Linked segment
            var linkPart = AttributedString(String(text[range]))
            linkPart.link = url
            result += linkPart

            cursor = range.upperBound
        }

        // Remaining plain text after last link
        if cursor < text.endIndex {
            result += AttributedString(String(text[cursor...]))
        }

        return result
    }
}

// MARK: - BlockNote model

private struct BNBlock: Decodable {
    let type: String
    let content: [BNInline]?
    let children: [BNBlock]?
}

private struct BNInline: Decodable {
    let type: String
    let text: String?
    let href: String?
    let content: [BNInline]?
    // `styles` intentionally omitted — we no longer apply inline formatting
}

// MARK: - HTML entity decoder

private extension String {
    var htmlEntitiesDecoded: String {
        self
            .replacingOccurrences(of: "&amp;",  with: "&")
            .replacingOccurrences(of: "&nbsp;", with: "\u{00A0}")
            .replacingOccurrences(of: "&lt;",   with: "<")
            .replacingOccurrences(of: "&gt;",   with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;",  with: "'")
            .replacingOccurrences(of: "&apos;", with: "'")
    }
}
