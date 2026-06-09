import Foundation
import Apollo
import ApolloWebSocket

final class NetworkClient {
    static let shared = NetworkClient()

    private var apollo: ApolloClient?

    private init() {}

    func configure(endpoint: String) {
        // erxes gateway always lives at /gateway/graphql (fileEndpoint, no w. subdomain)
        let base = endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint
        guard let url = URL(string: "\(base)/gateway/graphql") else { return }

        let store = ApolloStore()
        let provider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url
        )

        // WebSocket is only needed for subscriptions; skip it for now to avoid
        // "Connection invalid" errors at launch while subscriptions are not yet wired up.
        apollo = ApolloClient(networkTransport: transport, store: store)
    }

    var client: ApolloClient {
        guard let apollo else {
            fatalError("NetworkClient not configured — call ErxesSDK.configure() first")
        }
        return apollo
    }
}
