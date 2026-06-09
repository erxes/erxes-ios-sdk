import Foundation
import Combine
import UIKit

@MainActor
public final class AppViewModel: ObservableObject {

    // ── Connect response ──────────────────────────────────────────────────
    @Published private(set) var integrationId: String = ""
    @Published private(set) var customerId: String?
    @Published private(set) var visitorId: String?
    @Published private(set) var uiOptions: UIOptions = UIOptions(color: nil, wallpaper: nil, logo: nil)
    @Published private(set) var messengerData: MessengerData?
    @Published private(set) var isConnected = false
    @Published private(set) var connectError: String?

    // ── Active conversation ───────────────────────────────────────────────
    @Published var activeConversationId: String? {
        didSet { SessionManager.shared.lastConversationId = activeConversationId }
    }

    // ── Unread badge ──────────────────────────────────────────────────────
    @Published private(set) var totalUnreadCount: Int = 0

    // ── Supporters ────────────────────────────────────────────────────────
    @Published private(set) var supporters: [Supporter] = []

    // ── Config snapshot ───────────────────────────────────────────────────
    @Published private(set) var config: ErxesConfig?

    // MARK: - Connect

    func connect(config: ErxesConfig, user: ErxesUser?) async {
        self.config = config
        self.integrationId = config.integrationId
        self.visitorId = SessionManager.shared.visitorId
        self.activeConversationId = SessionManager.shared.lastConversationId

        NetworkClient.shared.configure(endpoint: config.endpoint)

        do {
            let response = try await performConnect(config: config, user: user)
            // Persist customer ID for future sessions
            if let cid = response.customerId {
                SessionManager.shared.cachedCustomerId = cid
                self.customerId = cid
            }
            self.uiOptions = response.uiOptions
            self.messengerData = response.messengerData
            self.isConnected = true
            await saveBrowserInfo()
            await fetchSupporters()
        } catch {
            ErxesLogger.error("connect() failed: \(error)")
            // Still show UI — user can browse even if connect fails
            self.isConnected = true
        }
    }

    // MARK: - REST connect call
    // Uses URLSession directly against the widget endpoint while Apollo codegen is pending.
    // Mirrors the `connect` GraphQL mutation in MessengerMutations.graphql.

    private func performConnect(config: ErxesConfig, user: ErxesUser?) async throws -> ConnectResponse {
        // GraphQL lives on fileEndpoint (no w. subdomain) — w. returns 405
        let base = config.fileEndpoint.hasSuffix("/") ? String(config.fileEndpoint.dropLast()) : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else {
            throw URLError(.badURL)
        }

        let mutation = """
        mutation connect($integrationId: String!, $visitorId: String, $cachedCustomerId: String, $email: String, $phone: String, $data: JSON) {
          widgetsMessengerConnect(integrationId: $integrationId, visitorId: $visitorId, cachedCustomerId: $cachedCustomerId, email: $email, phone: $phone, data: $data) {
            integrationId
            customerId
            visitorId
            languageCode
            uiOptions
            messengerData
          }
        }
        """

        var variables: [String: Any] = [
            "integrationId": config.integrationId,
            "visitorId": SessionManager.shared.visitorId
        ]
        if let cid = SessionManager.shared.cachedCustomerId { variables["cachedCustomerId"] = cid }
        if let email = user?.email  { variables["email"] = email }
        if let phone = user?.phone  { variables["phone"] = phone }

        let body: [String: Any] = ["query": mutation, "variables": variables]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "<non-utf8>"
        ErxesLogger.debug("connect HTTP \(statusCode) → \(raw.prefix(500))")

        guard !data.isEmpty else {
            ErxesLogger.error("connect: empty response body")
            return parseConnectResponse(nil)
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            ErxesLogger.error("connect: non-JSON body → \(raw.prefix(500))")
            return parseConnectResponse(nil)
        }

        if let errors = json["errors"] as? [[String: Any]] {
            ErxesLogger.error("connect GraphQL errors: \(errors)")
        }

        let connectData = (json["data"] as? [String: Any])?["widgetsMessengerConnect"] as? [String: Any]
        return parseConnectResponse(connectData)
    }

    private func parseConnectResponse(_ d: [String: Any]?) -> ConnectResponse {
        let ui   = d?["uiOptions"]    as? [String: Any]
        let md   = d?["messengerData"] as? [String: Any]
        let msgs = md?["messages"]    as? [String: Any]

        // Real API shape:
        //   uiOptions.primary.DEFAULT = "#7c3aed"  (not uiOptions.color)
        //   uiOptions.backgroundColor
        let primaryMap = ui?["primary"] as? [String: Any]
        let primaryHex = primaryMap?["DEFAULT"] as? String
                      ?? primaryMap?["default"] as? String
                      ?? ui?["color"] as? String   // fallback for older shape

        let uiOptions = UIOptions(
            color:     primaryHex,
            wallpaper: ui?["wallpaper"] as? String,
            logo:      ui?["logo"] as? String
        )

        // Real API shape:
        //   messages.greetings.title   = hero title
        //   messages.greetings.message = hero subtitle  (what we show as "greet")
        //   messages.welcome, .away, .thank  are top-level inside messages
        let greetings = msgs?["greetings"] as? [String: Any]
        let greetText = greetings?["message"] as? String   // subtitle under the title

        let onlineHoursRaw = md?["onlineHours"] as? [[String: Any]] ?? []
        let onlineHours = onlineHoursRaw.compactMap { h -> OnlineHour? in
            guard let day  = h["day"]  as? String,
                  let from = h["from"] as? String,
                  let to   = h["to"]   as? String else { return nil }
            return OnlineHour(day: day, from: from, to: to)
        }

        let messengerData = MessengerData(
            supporterIds:           (md?["supporterIds"] as? [String]) ?? [],
            notifyCustomer:         (md?["notifyCustomer"] as? Bool) ?? false,
            availabilityMethod:     md?["availabilityMethod"] as? String,
            isOnline:               (md?["isOnline"] as? Bool) ?? false,
            onlineHours:            onlineHours,
            timezone:               md?["timezone"] as? String,
            messages: GreetingMessages(
                greet:   greetText,
                away:    msgs?["away"]    as? String,
                thank:   msgs?["thank"]   as? String,
                welcome: msgs?["welcome"] as? String
            ),
            requireAuth:            (md?["requireAuth"] as? Bool) ?? false,
            showChat:               (md?["showChat"] as? Bool) ?? true,
            showLauncher:           (md?["showLauncher"] as? Bool) ?? true,
            forceLogoutWhenResolve: (md?["forceLogoutWhenResolve"] as? Bool) ?? false,
            showVideoCallRequest:   (md?["showVideoCallRequest"] as? Bool) ?? false
        )

        return ConnectResponse(
            integrationId: d?["integrationId"] as? String ?? integrationId,
            customerId:    d?["customerId"]    as? String,
            visitorId:     d?["visitorId"]     as? String,
            languageCode:  d?["languageCode"]  as? String,
            uiOptions:     uiOptions,
            messengerData: messengerData
        )
    }

    // MARK: - Fetch supporters

    func fetchSupporters() async {
        guard let config else { return }
        let base = config.fileEndpoint.hasSuffix("/") ? String(config.fileEndpoint.dropLast()) : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else { return }

        let query = """
        query widgetsMessengerSupporters($integrationId: String!) {
          widgetsMessengerSupporters(integrationId: $integrationId) {
            supporters {
              _id
              details { avatar fullName }
              isOnline
            }
            isOnline
          }
        }
        """
        let body: [String: Any] = [
            "query": query,
            "variables": ["integrationId": config.integrationId]
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData

        guard let (data, _) = try? await URLSession.shared.data(for: request) else { return }
        let raw = String(data: data, encoding: .utf8) ?? "<non-utf8>"
        ErxesLogger.debug("supporters response → \(raw.prefix(500))")

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let result = (json["data"] as? [String: Any])?["widgetsMessengerSupporters"] as? [String: Any],
              let list = result["supporters"] as? [[String: Any]] else {
            ErxesLogger.error("supporters: unexpected body → \(raw.prefix(300))")
            return
        }

        self.supporters = list.compactMap { s in
            let details = s["details"] as? [String: Any]
            return Supporter(
                id:       s["_id"] as? String ?? "",
                fullName: details?["fullName"] as? String,
                avatar:   details?["avatar"] as? String,
                isOnline: s["isOnline"] as? Bool ?? false
            )
        }
    }

    // MARK: - Save browser info

    func saveBrowserInfo() async {
        guard let config else { return }
        let base = config.fileEndpoint.hasSuffix("/") ? String(config.fileEndpoint.dropLast()) : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else { return }

        let mutation = """
        mutation saveBrowserInfo($customerId: String, $visitorId: String, $browserInfo: JSON!) {
          widgetsSaveBrowserInfo(customerId: $customerId, visitorId: $visitorId, browserInfo: $browserInfo) {
            _id content createdAt
          }
        }
        """
        var variables: [String: Any] = [
            "browserInfo": [
                "url": "ios-app",
                "hostname": Bundle.main.bundleIdentifier ?? "ios",
                "language": Locale.current.language.languageCode?.identifier ?? "en"
            ]
        ]
        if let cid = customerId     { variables["customerId"] = cid }
        else                        { variables["visitorId"]  = visitorId }

        let body: [String: Any] = ["query": mutation, "variables": variables]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        _ = try? await URLSession.shared.data(for: request)
    }

    // MARK: - Disconnect

    func disconnect() {
        SessionManager.shared.clearCustomer()
        customerId = nil; activeConversationId = nil
        isConnected = false; messengerData = nil
    }

    // MARK: - Helpers

    /// Priority: uiOptions.color from server → local appearance.primaryColor → default blue.
    var effectivePrimaryColor: UIColor {
        // Server color wins if connect has responded with a real color
        if let hex = uiOptions.color, !hex.isEmpty, let c = UIColor(hex: hex) { return c }
        // Fall back to locally configured color
        if let local = config?.appearance.primaryColor { return local }
        return UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1)
    }

    var showFAQTab: Bool { false }
}
