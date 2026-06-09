import Foundation
import OSLog

enum ErxesLogger {
    private static let logger = Logger(subsystem: "com.erxes.sdk", category: "ErxesSDK")

    static func debug(_ message: String) {
        logger.debug("\(message)")
    }

    static func error(_ message: String) {
        logger.error("\(message)")
    }
}
