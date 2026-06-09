import SwiftUI
import ErxesSDK

@main
struct ErxesExampleApp: App {
    init() {
        ErxesSDK.configure(
            ErxesConfig(
                endpoint: "https://your-erxes-endpoint.com",
                integrationId: "YOUR_INTEGRATION_ID"   // from erxes Dashboard → Integrations
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
