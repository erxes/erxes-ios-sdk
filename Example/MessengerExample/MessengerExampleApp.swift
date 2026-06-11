import SwiftUI
import MessengerSDK

@main
struct MessengerExampleApp: App {
    init() {
        MessengerSDK.configure(
            MessengerConfig(
                endpoint: "https://officenext.erxes.io",
                integrationId: "Z3MLJqFpkS70NgIpTkb6M"
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
