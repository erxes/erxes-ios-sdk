import Foundation

enum SDKLogger {
    static func debug(_ message: @autoclosure () -> String) {}
    static func error(_ message: @autoclosure () -> String) {}
}
