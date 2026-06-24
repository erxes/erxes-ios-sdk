import Foundation

/// Resolves an erxes file key into a full URL.
/// Keys stored in the DB look like "office-erxes-io/filename.png"
/// and must be served through the gateway's read-file endpoint.
///
/// Example:
///   key  = "office-erxes-io/avatar.png"
///   base = "https://officenext.erxes.io"
///   →    "https://officenext.erxes.io/gateway/read-file?key=office-erxes-io%2Favatar.png"
enum AttachmentURL {

    /// Returns a full URL string for a given file key/path.
    /// - If the value is already an http(s) URL it is returned as-is.
    /// - Otherwise it is percent-encoded and appended to the read-file endpoint.
    /// - Parameters:
    ///   - keyOrURL: raw key from API (e.g. "office-erxes-io/photo.png") or a full URL
    ///   - fileEndpoint: the file-serving base from `MessengerConfig.fileEndpoint`
    ///                   e.g. "https://officenext.erxes.io"  (NOT the widget w. URL)
    static func resolve(_ keyOrURL: String, fileEndpoint: String) -> URL? {
        // Already a full URL — return as-is
        if keyOrURL.hasPrefix("http://") || keyOrURL.hasPrefix("https://") {
            return URL(string: keyOrURL)
        }

        let base = fileEndpoint.hasSuffix("/") ? String(fileEndpoint.dropLast()) : fileEndpoint
        // Encode the key as a query *value*: `.urlQueryAllowed` leaves "/" (and other
        // reserved chars) unescaped, but the gateway needs the key's slash as "%2F" —
        // e.g. "office-erxes-io/photo.png" → "office-erxes-io%2Fphoto.png". With a
        // literal slash the gateway can't find the file and returns an empty body,
        // so the image never decodes and the spinner spins forever.
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "/+&=?#%")
        let encoded = keyOrURL.addingPercentEncoding(withAllowedCharacters: allowed) ?? keyOrURL
        return URL(string: "\(base)/gateway/read-file?key=\(encoded)")
    }
}
