import SwiftUI

struct TicketRowView: View {
    @EnvironmentObject var appVM: AppViewModel
    let ticket: Ticket
    @State private var isExpanded = false

    private var primary: Color { Color(appVM.effectivePrimaryColor) }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // ── Header row (always visible) ───────────────────────────────────
            HStack(spacing: 12) {
                // Status color circle
                Circle()
                    .strokeBorder(statusColor, lineWidth: 2)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().fill(statusColor.opacity(0.15)))

                Text(ticket.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Text(headerDateFormatted)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }

            // ── Detail section (collapsed / expanded) ────────────────────────
            if isExpanded {
                Divider().padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 12) {
                    // Dates row
                    HStack {
                        dateCell(label: "Start date", date: ticket.startDate)
                        Spacer()
                        dateCell(label: "Close date", date: ticket.targetDate)
                    }

                    // Description + ticket number
                    HStack(alignment: .top) {
                        if let desc = ticket.description, !desc.isEmpty {
                            MessageContentView(content: desc, isFromCustomer: false)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Spacer()
                        }

                        if let num = ticket.number {
                            Text("TICKET #\(num)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    // Status badge
                    if let status = ticket.status {
                        HStack(spacing: 6) {
                            Circle()
                                .strokeBorder(statusColor, lineWidth: 1.5)
                                .frame(width: 16, height: 16)
                                .overlay(Circle().fill(statusColor.opacity(0.15)))
                            Text(status.name)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(statusColor.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .strokeBorder(statusColor.opacity(0.25), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                Divider().padding(.horizontal, 16)

                // Created at footer
                HStack(spacing: 6) {
                    Text("Created at:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(createdAtFormatted)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.07), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }

    // MARK: - Date cell

    private func dateCell(label: String, date: Date?) -> some View {
        HStack(spacing: 5) {
            Image(systemName: "calendar.badge.clock")
                .font(.caption)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let date {
                    Text(shortDate(date))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.primary)
                }
            }
        }
    }

    // MARK: - Helpers

    private var statusColor: Color {
        guard let hex = ticket.status?.color, !hex.isEmpty,
              let c = UIColor(hex: hex) else { return Color(appVM.effectivePrimaryColor) }
        return Color(c)
    }

    private var headerDateFormatted: String {
        Self.headerDateFmt.string(from: ticket.createdAt)
    }

    private var createdAtFormatted: String {
        Self.headerDateFmt.string(from: ticket.createdAt)
    }

    private func shortDate(_ date: Date) -> String {
        Self.shortDateFmt.string(from: date)
    }

    // MARK: - Static formatters (created once, not per render)

    private static let headerDateFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    private static let shortDateFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
}
