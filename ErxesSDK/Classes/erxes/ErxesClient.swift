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
    var widgetsApiUrlString = "http://localhost:3300"
    var apiUrlString = "ws://localhost:3300"

    func setupClient(widgetsApiUrl: String, apiUrlString: String) {
        self.widgetsApiUrlString = widgetsApiUrl
        self.apiUrlString = apiUrlString
    }


    private lazy var networkTransport: HTTPNetworkTransport = {
        let transport = HTTPNetworkTransport(url: URL(string: "\(widgetsApiUrlString)/graphql")!)
        transport.delegate = self
        return transport
    }()

    private lazy var webSocket = WebSocketTransport(request: URLRequest(url: URL(string: "\(apiUrlString)/subscriptions")!), sendOperationIdentifiers: false, reconnectionInterval: 0.5, connectingPayload: nil)

    private lazy var splitNetworkTransport = SplitNetworkTransport(httpNetworkTransport: self.networkTransport, webSocketNetworkTransport: self.webSocket)
    private(set) lazy var client = ApolloClient(networkTransport: self.splitNetworkTransport)

}

extension ErxesClient: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }


//  func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                          shouldSend request: URLRequest) -> Bool {
//    // If there's an authenticated user, send the request. If not, don't.
//    return UserManager.shared.hasAuthenticatedUser
//  }

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {

        // Get the existing headers, or create new ones if they're nil
        let headers = request.allHTTPHeaderFields ?? [String: String]()

        // Add any new headers you need
//    headers["Authorization"] = "Bearer \(UserManager.shared.currentAuthToken)"

        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers

      
    }
}





extension ErxesClient: HTTPNetworkTransportTaskCompletedDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          didCompleteRawTaskForRequest request: URLRequest,
                          withData data: Data?,
                          response: URLResponse?,
                          error: Error?) {

    }
}


