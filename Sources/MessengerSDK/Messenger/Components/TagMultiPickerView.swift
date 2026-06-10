import SwiftUI

struct TagMultiPickerView: View {
    let tags: [TicketTag]
    @Binding var selected: Set<String>
    let primary: Color
    var backgroundColor: Color = Color(.systemBackground)

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(tags) { tag in
                    let isSelected = selected.contains(tag.id)
                    Button {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                            if isSelected { selected.remove(tag.id) }
                            else          { selected.insert(tag.id) }
                        }
                    } label: {
                        HStack {
                            Text(tag.name)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(primary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("Select Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(primary)
                }
            }
        }
    }
}
