import SwiftUI
import ErxesSDK

@main
struct ErxesExampleApp: App {
    init() {
        ErxesSDK.configure(
            ErxesConfig(
                endpoint: "https://officenext.erxes.io",
                integrationId: "9S6seo9wawN6cou8v"
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
