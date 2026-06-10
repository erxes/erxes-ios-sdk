import SwiftUI

struct TicketsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = TicketListViewModel()
    @State private var showCreateSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                PageHeroHeader(
                    title: "Tickets",
                    subtitle: "Track your support requests"
                )
                .environmentObject(appVM)

                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 60)
                } else if viewModel.tickets.isEmpty {
                    emptyState
                        .padding(.top, 60)
                        .padding(.horizontal, 32)
                } else {
                    // Create button above list
                    if appVM.messengerData?.ticketConfig != nil {
                        Button { showCreateSheet = true } label: {
                            Label("Create a ticket", systemImage: "plus")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color(appVM.effectivePrimaryColor))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(appVM.effectivePrimaryColor).opacity(0.08),
                                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }

                    ticketList
                        .padding(.top, 10)
                }

                Spacer().frame(height: 80)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear { viewModel.load(appVM: appVM) }
        .sheet(isPresented: $showCreateSheet) {
            CreateTicketView(
                ticketConfig: appVM.messengerData?.ticketConfig,
                onCreated: { viewModel.load(appVM: appVM) }
            )
            .environmentObject(appVM)
        }
    }

    // MARK: - Ticket list

    private var ticketList: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.tickets) { ticket in
                TicketRowView(ticket: ticket)
                    .environmentObject(appVM)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "ticket")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(Color(appVM.effectivePrimaryColor).opacity(0.70))
                .frame(width: 84, height: 84)
                .background(Color(appVM.effectivePrimaryColor).opacity(0.08), in: Circle())
                .overlay(Circle().strokeBorder(Color(appVM.effectivePrimaryColor).opacity(0.15), lineWidth: 1))

            VStack(spacing: 8) {
                Text("No tickets yet")
                    .font(.system(size: 18, weight: .semibold))
                Text("Create a ticket and we'll get back\nto you as soon as possible.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }

            Button {
                showCreateSheet = true
            } label: {
                Label("Create a ticket", systemImage: "plus")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 13)
                    .background(Color(appVM.effectivePrimaryColor), in: Capsule())
            }
            .padding(.top, 4)
        }
    }
}
