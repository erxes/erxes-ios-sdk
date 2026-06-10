import SwiftUI
import MessengerSDK

@main
struct MessengerExampleApp: App {
    init() {
        MessengerSDK.configure(
            MessengerConfig(
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
