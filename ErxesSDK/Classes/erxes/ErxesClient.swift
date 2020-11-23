//
//  ErxesClient.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/15/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo

class ErxesClient {
    static let shared = ErxesClient()

    var apiUrl = "http://localhost:3300"
    var socketUrl = "ws://localhost:3300"
    
    func setupClient(apiUrlString: String) {
        self.apiUrl = apiUrlString + "/graphql"
        
        if apiUrlString.contains("http") {
            socketUrl = apiUrlString.replacingOccurrences(of: "http", with: "ws") + "/subscriptions"
        } else if apiUrlString.contains("https") {
            socketUrl = apiUrlString.replacingOccurrences(of: "https", with: "wss") + "/subscriptions"
        }
    }
    
    private lazy var webSocketTransport: WebSocketTransport = {
        let url = URL(string: self.socketUrl)!
        let request = URLRequest(url: url)
        return WebSocketTransport(request: request)
    }()
    
    /// An HTTP transport to use for queries and mutations
    private lazy var normalTransport: RequestChainNetworkTransport = {
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let url = URL(string: self.apiUrl)!
        return RequestChainNetworkTransport(interceptorProvider: LegacyInterceptorProvider(store: store), endpointURL: url)
    }()
    
    /// A split network transport to allow the use of both of the above
    /// transports through a single `NetworkTransport` instance.
    private lazy var splitNetworkTransport = SplitNetworkTransport(
        uploadingNetworkTransport: self.normalTransport,
        webSocketNetworkTransport: self.webSocketTransport
    )
    
    private(set) lazy var client: ApolloClient = {
        // The cache is necessary to set up the store, which we're going to hand to the provider
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        return ApolloClient(networkTransport: splitNetworkTransport,
                            store: store)
    }()
}


struct NetworkInterceptorProvider: InterceptorProvider {
    
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            LegacyCacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            LegacyParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            LegacyCacheWriteInterceptor(store: self.store)
        ]
    }
}

