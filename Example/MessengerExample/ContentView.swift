import SwiftUI
import MessengerSDK

struct ContentView: View {
    @ObservedObject private var sdk = MessengerSDK.shared
    @State private var isLoggedIn = false
    @State private var email = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("MessengerSDK Example")
                    .font(.title.bold())

                if !isLoggedIn {
                    VStack(spacing: 12) {
                        TextField("Email (optional)", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        Button("Set User") {
                            MessengerSDK.setUser(MessengerUser(
                                email: email.isEmpty ? nil : email,
                                name: "Test User"
                            ))
                            isLoggedIn = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, 40)
                } else {
                    Button("Clear User (Logout)") {
                        MessengerSDK.clearUser()
                        isLoggedIn = false
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("Demo")
        }
        // Floating 48×48 launcher — draggable between top-right and bottom-right.
        // Only shown once the SDK has connected.
        .overlay {
            if sdk.isReady {
                MessengerLaunchButton()
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: sdk.isReady)
    }
}
