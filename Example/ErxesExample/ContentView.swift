import SwiftUI
import ErxesSDK

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var email = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("ErxesSDK Example")
                    .font(.title.bold())

                if !isLoggedIn {
                    VStack(spacing: 12) {
                        TextField("Email (optional)", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        Button("Set User") {
                            ErxesSDK.setUser(ErxesUser(email: email.isEmpty ? nil : email, name: "Test User"))
                            isLoggedIn = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, 40)
                } else {
                    Button("Clear User (Logout)") {
                        ErxesSDK.clearUser()
                        isLoggedIn = false
                    }
                    .buttonStyle(.bordered)
                }

                Divider().padding(.horizontal, 40)

                OpenMessengerButton()
            }
            .padding()
            .navigationTitle("Demo")
        }
    }
}

struct OpenMessengerButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            openMessenger()
        } label: {
            Label("Open Messenger", systemImage: "message.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding(.horizontal, 40)
    }

    private func openMessenger() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else { return }
        ErxesSDK.showMessenger(from: root)
    }
}
