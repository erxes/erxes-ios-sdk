import SwiftUI

struct DateSeparatorView: View {
    let label: String

    var body: some View {
        HStack {
            line
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
            line
        }
        .padding(.vertical, 8)
    }

    private var line: some View {
        Rectangle()
            .fill(Color(.separator))
            .frame(height: 0.5)
    }
}
