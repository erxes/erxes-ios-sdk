import SwiftUI
import MessengerSDK

@main
struct MessengerExampleApp: App {
    init() {
        MessengerSDK.configure(
            MessengerConfig(
                endpoint: "https://officenext.erxes.io",
                integrationId: "Z3MLJqFpkS70NgIpTkb6M",
                displayMode: .chat,
                homeActions: [
                    ActionItem(id: "search", title: "Search", systemIcon: "magnifyingglass")
                ],
                drawerActions: [
                    ActionItem(id: "profile", title: "Profile", systemIcon: "person.circle"),
                    ActionItem(id: "settings", title: "Settings", systemIcon: "gearshape")
                ]
            )
        )
        // Demonstrate the action callback (native host path; RN hosts get `onAction`).
        MessengerSDK.shared.onAction = { id in
            print("[Example] chat-mode action tapped:", id)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
