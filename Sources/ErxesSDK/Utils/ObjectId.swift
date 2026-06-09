import Foundation

/// Generates a MongoDB ObjectId-like 24-character hex string.
/// Format: 4-byte big-endian timestamp + 8 random bytes → 12 bytes → 24 hex chars.
/// Mirrors the RN SDK's createObjectIdLikeString() so IDs are compatible.
enum ObjectIdGenerator {
    static func generate() -> String {
        let timestamp = UInt32(Date().timeIntervalSince1970)
        var bytes = [UInt8](repeating: 0, count: 12)

        // Big-endian timestamp in first 4 bytes
        bytes[0] = UInt8((timestamp >> 24) & 0xFF)
        bytes[1] = UInt8((timestamp >> 16) & 0xFF)
        bytes[2] = UInt8((timestamp >> 8)  & 0xFF)
        bytes[3] = UInt8( timestamp        & 0xFF)

        // 8 cryptographically random bytes
        var randomBytes = [UInt8](repeating: 0, count: 8)
        _ = SecRandomCopyBytes(kSecRandomDefault, 8, &randomBytes)
        bytes.replaceSubrange(4..., with: randomBytes)

        return bytes.map { String(format: "%02x", $0) }.joined()
    }
}
