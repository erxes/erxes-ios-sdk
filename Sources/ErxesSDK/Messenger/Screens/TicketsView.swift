import SwiftUI

struct TicketsView: View {
    @EnvironmentObject var appVM: AppViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Tickets")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Your tickets")
                    .font(.title2.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.secondarySystemBackground))

            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "ticket")
                    .font(.system(size: 48))
                    .foregroundStyle(Color(.systemGray3))
                Text("No tickets yet")
                    .font(.headline)
                Text("Issue a ticket and we'll get back to you as soon as possible.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button {
                    // TODO: navigate to new ticket form
                } label: {
                    Label("Create a ticket", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(appVM.effectivePrimaryColor), in: Capsule())
                }
            }

            Spacer()
        }
    }
}
