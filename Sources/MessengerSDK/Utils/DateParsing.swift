import Foundation

/// Parses the date shapes the backend returns: Unix-millisecond numbers (as
/// `Double`/`Int`), numeric millisecond strings, and ISO8601 strings (with or
/// without fractional seconds). Previously duplicated across three ViewModels.
enum DateParsing {
    static func date(from value: Any?) -> Date? {
        if let ms = value as? Double { return Date(timeIntervalSince1970: ms / 1_000) }
        if let ms = value as? Int    { return Date(timeIntervalSince1970: Double(ms) / 1_000) }
        if let str = value as? String {
            if let ms = Double(str) { return Date(timeIntervalSince1970: ms / 1_000) }
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = iso.date(from: str) { return d }
            iso.formatOptions = [.withInternetDateTime]
            return iso.date(from: str)
        }
        return nil
    }
}
