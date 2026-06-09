import Foundation

/// A single item in the flat chat list — either a date separator or a message.
public enum ChatRow: Identifiable {
    case dateSeparator(id: String, label: String)
    case message(id: String, message: Message, isFirstInGroup: Bool, isLastInGroup: Bool)

    public var id: String {
        switch self {
        case .dateSeparator(let id, _): return id
        case .message(let id, _, _, _): return id
        }
    }
}

/// Groups consecutive messages from the same sender within a 5-minute window.
/// Mirrors RN SDK's buildChatRows() in utils/messages.ts.
public enum MessageGrouper {

    private static let groupingWindow: TimeInterval = 5 * 60  // 5 minutes

    public static func buildChatRows(messages: [Message]) -> [ChatRow] {
        var rows: [ChatRow] = []

        let filtered = messages.filter { !$0.content.isEmpty }
        guard !filtered.isEmpty else { return rows }

        var currentDateKey = ""

        for (index, message) in filtered.enumerated() {
            let dateKey = dayKey(for: message.createdAt)

            // Insert date separator when the day changes
            if dateKey != currentDateKey {
                currentDateKey = dateKey
                rows.append(.dateSeparator(
                    id: "sep-\(dateKey)",
                    label: friendlyDateLabel(for: message.createdAt)
                ))
            }

            let prev = index > 0 ? filtered[index - 1] : nil
            let next = index < filtered.count - 1 ? filtered[index + 1] : nil

            let isFirstInGroup = !sameGroup(message, prev)
            let isLastInGroup  = !sameGroup(message, next)

            rows.append(.message(
                id: message.id,
                message: message,
                isFirstInGroup: isFirstInGroup,
                isLastInGroup: isLastInGroup
            ))
        }

        return rows
    }

    // MARK: - Helpers

    private static func sameGroup(_ a: Message, _ b: Message?) -> Bool {
        guard let b else { return false }
        guard a.isFromCustomer == b.isFromCustomer else { return false }
        return abs(a.createdAt.timeIntervalSince(b.createdAt)) <= groupingWindow
    }

    private static func dayKey(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    private static func friendlyDateLabel(for date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date)     { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f.string(from: date)
    }
}
