import Foundation
import Combine
import UIKit
import SwiftUI

@MainActor
public final class AppViewModel: ObservableObject {

    // ── Connect response ──────────────────────────────────────────────────
    @Published private(set) var integrationId: String = ""
    @Published private(set) var customerId: String?
    @Published private(set) var visitorId: String?
    @Published private(set) var uiOptions: UIOptions = UIOptions(color: nil, textColor: nil, backgroundColor: nil, wallpaper: nil, logo: nil)
    @Published private(set) var messengerData: MessengerData?
    @Published private(set) var isConnected = false
    @Published private(set) var connectError: String?

    /// True once the visitor has an identity (host-provided email/phone, a previously
    /// captured requireAuth contact, or a registered customerId). Gates the auth form.
    @Published private(set) var isIdentified = false

    /// When the integration's messengerData requires auth, visitors must supply an
    /// email/phone before starting a conversation.
    var requireAuth: Bool { messengerData?.requireAuth ?? false }

    // ── Active conversation ───────────────────────────────────────────────
    @Published var activeConversationId: String? {
        didSet { SessionManager.shared.lastConversationId = activeConversationId }
    }

    // ── Message typed in the home input bar, waiting to be sent ──────────
    /// Set by homeInputBar send, consumed by MessagesView to open a new chat.
    @Published var pendingHomeMessage: String? = nil

    // ── Unread badge ──────────────────────────────────────────────────────
    @Published private(set) var totalUnreadCount: Int = 0

    // ── Supporters ────────────────────────────────────────────────────────
    @Published private(set) var supporters: [Supporter] = []

    // ── Config snapshot ───────────────────────────────────────────────────
    @Published private(set) var config: MessengerConfig?

    // MARK: - Connect

    func connect(config: MessengerConfig, user: MessengerUser?) async {
        // Batch initial non-network state into one render pass
        self.config = config
        self.integrationId = config.integrationId
        // Reset persisted identity if the integration changed, so we don't reuse the
        // previous integration's customerId (which would surface its tickets/chats).
        SessionManager.shared.bind(integrationId: config.integrationId)
        self.visitorId = SessionManager.shared.visitorId
        self.activeConversationId = SessionManager.shared.lastConversationId
        // A host-provided email/phone, or a contact captured on a previous launch,
        // counts as already identified — skip the requireAuth form in those cases.
        self.isIdentified = SessionManager.shared.isIdentified
            || (user?.email?.isEmpty == false)
            || (user?.phone?.isEmpty == false)
        self.isConnected = true   // show UI immediately; colours fill in after network

        NetworkClient.shared.configure(endpoint: config.endpoint)

        do {
            let response = try await performConnect(config: config, user: user)
            if let cid = response.customerId {
                SessionManager.shared.cachedCustomerId = cid
                self.customerId = cid
            }
            // Single batch update — one SwiftUI re-render instead of three
            self.uiOptions    = response.uiOptions
            self.messengerData = response.messengerData
            // Non-blocking fire-and-forget; don't block UI
            Task { await saveBrowserInfo() }
            Task { await fetchSupporters() }
        } catch {
            SDKLogger.error("connect() failed: \(error)")
        }
    }

    // MARK: - requireAuth identity capture

    enum ContactKind: String { case email, phone }

    /// Saves the visitor's email/phone (and optional name) onto the customer record
    /// created by connect, via the `widgetsTicketCustomersEdit` mutation. The returned
    /// `_id` is persisted as the cachedCustomerId so the next connect re-identifies the
    /// same customer. Used by the requireAuth form before a conversation can start.
    func identify(kind: ContactKind, value: String, firstName: String?, lastName: String?) async throws {
        guard let config else { throw GraphQL.GraphQLError(message: "Not connected") }
        // CustomersEdit edits an existing customer — connect always returns one (even
        // for anonymous visitors), so this should be populated by now.
        guard let customerId = self.customerId ?? SessionManager.shared.cachedCustomerId else {
            throw GraphQL.GraphQLError(message: "No customer to identify")
        }

        var variables: [String: Any] = ["customerId": customerId]
        if let f = firstName, !f.isEmpty { variables["firstName"] = f }
        if let l = lastName,  !l.isEmpty { variables["lastName"]  = l }
        switch kind {
        case .email: variables["emails"] = [value]
        case .phone: variables["phones"] = [value]
        }

        let obj = try await GraphQL.object(
            endpoint: config.fileEndpoint,
            operation: "widgetsTicketCustomersEdit",
            query: Self.customersEditMutation,
            variables: variables,
            field: "widgetsTicketCustomersEdit"
        )

        if let cid = obj["_id"] as? String, !cid.isEmpty {
            SessionManager.shared.cachedCustomerId = cid
            self.customerId = cid
        }
        SessionManager.shared.isIdentified = true
        self.isIdentified = true
    }

    /// Edits the connect-created customer with the requireAuth contact details.
    /// The returned `_id` becomes the cachedCustomerId passed to the next connect.
    private static let customersEditMutation = """
    mutation CustomersEdit($customerId: String!, $firstName: String, $lastName: String, $emails: [String], $phones: [String]) {
      widgetsTicketCustomersEdit(customerId: $customerId, firstName: $firstName, lastName: $lastName, emails: $emails, phones: $phones) {
        _id
        email
        emails
        firstName
        lastName
        phone
        phones
        primaryEmail
        primaryPhone
      }
    }
    """

    /// Shared connect mutation — used by both the initial handshake and identify().
    private static let connectMutation = """
    mutation connect($integrationId: String!, $visitorId: String, $cachedCustomerId: String, $email: String, $phone: String, $data: JSON) {
      widgetsMessengerConnect(integrationId: $integrationId, visitorId: $visitorId, cachedCustomerId: $cachedCustomerId, email: $email, phone: $phone, data: $data) {
        integrationId
        customerId
        visitorId
        languageCode
        uiOptions
        messengerData
        ticketConfig
      }
    }
    """

    // MARK: - REST connect call
    // Uses URLSession directly against the widget endpoint while Apollo codegen is pending.
    // Mirrors the `connect` GraphQL mutation in MessengerMutations.graphql.

    private func performConnect(config: MessengerConfig, user: MessengerUser?) async throws -> ConnectResponse {
        // GraphQL lives on fileEndpoint (no w. subdomain) — w. returns 405
        let base = config.fileEndpoint.hasSuffix("/") ? String(config.fileEndpoint.dropLast()) : config.fileEndpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else {
            throw URLError(.badURL)
        }

        let mutation = Self.connectMutation

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
        SDKLogger.debug("connect HTTP \(statusCode) → \(raw.prefix(3000))")

        guard !data.isEmpty else {
            SDKLogger.error("connect: empty response body")
            return parseConnectResponse(nil)
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            SDKLogger.error("connect: non-JSON body → \(raw.prefix(500))")
            return parseConnectResponse(nil)
        }

        if let errors = json["errors"] as? [[String: Any]] {
            SDKLogger.error("connect GraphQL errors: \(errors)")
        }

        let connectData = (json["data"] as? [String: Any])?["widgetsMessengerConnect"] as? [String: Any]

        // Debug: dump top-level keys and messengerData keys so we can verify ticketConfig location
        SDKLogger.debug("connectData keys: \(connectData?.keys.sorted() ?? [])")
        if let md = connectData?["messengerData"] as? [String: Any] {
            SDKLogger.debug("messengerData keys: \(md.keys.sorted())")
            SDKLogger.debug("ticketConfig in md: \(md["ticketConfig"] != nil)")
        }

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
                      ?? ui?["color"] as? String

        let uiOptions = UIOptions(
            color:           primaryHex,
            textColor:       ui?["textColor"] as? String,
            backgroundColor: ui?["backgroundColor"] as? String,
            wallpaper:       ui?["wallpaper"] as? String,
            logo:            ui?["logo"] as? String
        )

        // messages.greetings.title  → hero headline
        // messages.greetings.message → hero subtitle
        // messages.welcome / .away / .thank → top-level
        let greetings  = msgs?["greetings"] as? [String: Any]
        let greetTitle = greetings?["title"]   as? String
        let greetText  = greetings?["message"] as? String

        let onlineHoursRaw = md?["onlineHours"] as? [[String: Any]] ?? []
        let onlineHours = onlineHoursRaw.compactMap { h -> OnlineHour? in
            guard let day  = h["day"]  as? String,
                  let from = h["from"] as? String,
                  let to   = h["to"]   as? String else { return nil }
            return OnlineHour(day: day, from: from, to: to)
        }

        // ── ticketConfig — lives at the TOP LEVEL of widgetsMessengerConnect, not inside messengerData
        SDKLogger.debug("raw ticketConfig from d: \(String(describing: d?["ticketConfig"]))")
        var ticketConfig: TicketConfig?
        if let tc = d?["ticketConfig"] as? [String: Any],
           let tcId = tc["_id"] as? String,
           let tcPipelineId = tc["pipelineId"] as? String,
           let tcStatusId = tc["selectedStatusId"] as? String {
            let ff = tc["formFields"] as? [String: Any]
            func fieldCfg(_ key: String) -> TicketFieldConfig? {
                guard let f = ff?[key] as? [String: Any] else { return nil }
                let show = f["isShow"] as? Bool ?? false
                return TicketFieldConfig(
                    isShow:      show,
                    label:       f["label"]       as? String,
                    placeholder: f["placeholder"] as? String,
                    order:       f["order"]       as? Int ?? 99
                )
            }
            ticketConfig = TicketConfig(
                id:               tcId,
                name:             tc["name"] as? String ?? "",
                pipelineId:       tcPipelineId,
                channelId:        tc["channelId"] as? String,
                selectedStatusId: tcStatusId,
                parentId:         tc["parentId"] as? String,
                formFields: TicketFormFields(
                    name:        fieldCfg("name"),
                    description: fieldCfg("description"),
                    attachment:  fieldCfg("attachment"),
                    tags:        fieldCfg("tags")
                )
            )
        }

        SDKLogger.debug("ticketConfig parsed OK: \(ticketConfig?.id ?? "NIL — guard failed")")

        // ── websiteApps — lives inside messengerData ──────────────────────────
        let websiteApps: [WebsiteApp] = (md?["websiteApps"] as? [[String: Any]] ?? []).compactMap { w in
            guard let wid = w["_id"] as? String,
                  let kind = w["kind"] as? String,
                  let creds = w["credentials"] as? [String: Any],
                  let urlStr = creds["url"] as? String, !urlStr.isEmpty,
                  let buttonText = creds["buttonText"] as? String else { return nil }
            return WebsiteApp(
                id: wid,
                kind: kind,
                buttonText: buttonText,
                description: creds["description"] as? String,
                url: urlStr,
                showInInbox: w["showInInbox"] as? Bool ?? false
            )
        }

        let lnk = md?["links"] as? [String: Any]
        let socialLinks = SocialLinks(
            facebook:  lnk?["facebook"]  as? String,
            instagram: lnk?["instagram"] as? String,
            twitter:   lnk?["twitter"]   as? String ?? lnk?["x"] as? String,
            youtube:   lnk?["youtube"]   as? String,
            linkedin:  lnk?["linkedin"]  as? String,
            discord:   lnk?["discord"]   as? String,
            github:    lnk?["github"]    as? String
        )

        let messengerData = MessengerData(
            supporterIds:           (md?["supporterIds"] as? [String]) ?? [],
            notifyCustomer:         (md?["notifyCustomer"] as? Bool) ?? false,
            availabilityMethod:     md?["availabilityMethod"] as? String,
            isOnline:               (md?["isOnline"] as? Bool) ?? false,
            onlineHours:            onlineHours,
            timezone:               md?["timezone"] as? String,
            messages: GreetingMessages(
                greetTitle: greetTitle,
                greet:      greetText,
                away:       msgs?["away"]    as? String,
                thank:      msgs?["thank"]   as? String,
                welcome:    msgs?["welcome"] as? String
            ),
            links:                  socialLinks,
            ticketConfig:           ticketConfig,
            knowledgeBaseTopicId:   (md?["knowledgeBaseTopicId"] as? String).flatMap { $0.isEmpty ? nil : $0 },
            websiteApps:            websiteApps,
            responseRate:           md?["responseRate"] as? String,
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

        guard let json = try? await GraphQL.send(
            endpoint: config.fileEndpoint,
            operation: "widgetsMessengerSupporters",
            query: query,
            variables: ["integrationId": config.integrationId]
        ) else { return }

        guard let result = (json["data"] as? [String: Any])?["widgetsMessengerSupporters"] as? [String: Any],
              let list = result["supporters"] as? [[String: Any]] else {
            SDKLogger.error("supporters: unexpected body")
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

        _ = try? await GraphQL.send(
            endpoint: config.fileEndpoint,
            operation: "widgetsSaveBrowserInfo",
            query: mutation,
            variables: variables
        )
    }

    // MARK: - Disconnect

    func disconnect() {
        SessionManager.shared.clearCustomer()
        customerId = nil; activeConversationId = nil
        isConnected = false; messengerData = nil
    }

    // MARK: - Helpers

    // Memoized color instances. Constructing a UIColor on every access returns a
    // NEW reference each time, which defeats SwiftUI's view diffing: any view that
    // receives `effective*Color` is treated as "changed" on every `body` pass and
    // re-renders. During the keyboard animation `body` runs every frame, so this
    // re-rendered every visible message bubble ~60–120×/sec → CPU pegged >100%.
    // Caching by source key returns the SAME instance until the source changes,
    // letting SwiftUI skip unchanged subtrees.
    private var primaryColorCache: (key: String, color: UIColor)?
    private var backgroundColorCache: (key: String, color: UIColor)?
    private var textColorCache: (key: String, color: UIColor)?

    /// Priority: uiOptions.color from server → local appearance.primaryColor → default blue.
    var effectivePrimaryColor: UIColor {
        let key = uiOptions.color ?? "_local_"
        if let cached = primaryColorCache, cached.key == key { return cached.color }

        let color: UIColor
        if let hex = uiOptions.color, !hex.isEmpty, let c = UIColor(hex: hex) {
            color = c
        } else if let local = config?.appearance.primaryColor {
            color = local
        } else {
            color = UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1)
        }
        primaryColorCache = (key, color)
        return color
    }

    /// Background color used for both the hero base and all container areas.
    /// Server value wins; falls back to a fixed dark near-black so the SDK never
    /// inherits the host app's light/dark theme.
    var effectiveBackgroundColor: UIColor {
        let key = uiOptions.backgroundColor ?? "_default_"
        if let cached = backgroundColorCache, cached.key == key { return cached.color }

        let color: UIColor
        if let hex = uiOptions.backgroundColor, !hex.isEmpty, let c = UIColor(hex: hex) {
            color = c
        } else {
            color = UIColor(red: 0.05, green: 0.05, blue: 0.08, alpha: 1)
        }
        backgroundColorCache = (key, color)
        return color
    }

    /// Alias kept so all call-sites compile without changes.
    var effectiveContainerBackgroundColor: UIColor { effectiveBackgroundColor }

    /// ColorScheme derived from effectiveBackgroundColor so the entire SDK
    /// ignores the device's light/dark setting and always looks correct against
    /// the configured background.
    var effectiveColorScheme: ColorScheme {
        effectiveBackgroundColor.isLight ? .light : .dark
    }

    /// Standard UI label color resolved against the SDK's effective appearance.
    /// Use for body content (e.g. article HTML) that sits on the container
    /// background, rather than the hero textColor which is tuned for the gradient.
    var effectiveLabelColor: UIColor {
        let style: UIUserInterfaceStyle = effectiveColorScheme == .dark ? .dark : .light
        return UIColor.label.resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
    }

    /// Text color used on the hero/gradient background.
    /// Falls back to white when not set (works on any dark background).
    var effectiveTextColor: UIColor {
        let key = uiOptions.textColor ?? "_default_"
        if let cached = textColorCache, cached.key == key { return cached.color }

        let color: UIColor
        if let hex = uiOptions.textColor, !hex.isEmpty, let c = UIColor(hex: hex) {
            color = c
        } else {
            color = .white
        }
        textColorCache = (key, color)
        return color
    }

    /// Human-readable reply time label from responseRate field.
    var replyTimeLabel: String {
        switch messengerData?.responseRate {
        case "minutes": return "Replies in minutes"
        case "hours":   return "Replies in a few hours"
        case "days":    return "Replies in a day or two"
        default:        return "We'll reply as soon as possible"
        }
    }

    /// The Help (knowledge base) tab is shown only when the integration has a
    /// knowledge base topic configured on its messengerData.
    var knowledgeBaseTopicId: String? { messengerData?.knowledgeBaseTopicId }
    var showHelpTab: Bool { knowledgeBaseTopicId != nil }
}
