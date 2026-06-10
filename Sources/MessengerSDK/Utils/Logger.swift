import Foundation
import OSLog

enum SDKLogger {
    private static let logger = Logger(subsystem: "com.messenger.sdk", category: "MessengerSDK")

    static func debug(_ message: String) {
        logger.debug("\(message)")
    }

    static func error(_ message: String) {
        logger.error("\(message)")
    }
}
