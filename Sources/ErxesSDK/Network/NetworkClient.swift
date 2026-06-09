import Foundation
import Apollo
import ApolloWebSocket

final class NetworkClient {
    static let shared = NetworkClient()

    private var apollo: ApolloClient?

    private init() {}

    func configure(endpoint: String) {
        guard let url = URL(string: "\(endpoint)/graphql") else { return }

        let store = ApolloStore()
        let sessionClient = URLSessionClient()
        let provider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url
        )

        guard let wsURL = URL(string: endpoint.replacingOccurrences(of: "http", with: "ws") + "/graphql") else {
            apollo = ApolloClient(networkTransport: transport, store: store)
            return
        }

        let webSocket = WebSocket(url: wsURL, protocol: .graphql_ws)
        let wsTransport = WebSocketTransport(websocket: webSocket)
        let splitTransport = SplitNetworkTransport(
            uploadingNetworkTransport: transport,
            webSocketNetworkTransport: wsTransport
        )

        apollo = ApolloClient(networkTransport: splitTransport, store: store)
    }

    var client: ApolloClient {
        guard let apollo else {
            fatalError("NetworkClient not configured — call ErxesSDK.configure() first")
        }
        return apollo
    }
}
