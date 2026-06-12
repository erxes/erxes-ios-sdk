import SwiftUI
import MessengerSDK

struct ContentView: View {
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
        // Use the native overlay-window launcher — the SAME path RN/Flutter hosts
        // drive via showLauncher(). This makes the Example reproduce the floating
        // passthrough-window behaviour (hit-testing, key-window, sheet presentation)
        // so launcher fixes can be verified here before cutting a release.
        .onAppear { MessengerSDK.showLauncher() }
        .onDisappear { MessengerSDK.hideLauncher() }
    }
}
