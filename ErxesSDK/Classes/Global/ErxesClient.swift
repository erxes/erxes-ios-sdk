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
    var widgetsApiUrlString = "http://localhost:3100"
    var apiUrlString = "ws://localhost:3300"
    
    func setupClient(widgetsApiUrl:String,apiUrlString:String){
        self.widgetsApiUrlString = widgetsApiUrl
        self.apiUrlString = apiUrlString
    }
    
    private lazy var networkTransport = HTTPNetworkTransport(
        url: URL(string: "\(widgetsApiUrlString)/graphql")!
    )
    
    private lazy var webSocket = WebSocketTransport(request: URLRequest(url: URL(string: "\(apiUrlString)/subscriptions")!), sendOperationIdentifiers: false, reconnectionInterval: 0.5, connectingPayload: nil)

    private lazy var splitNetworkTransport = SplitNetworkTransport(httpNetworkTransport: self.networkTransport, webSocketNetworkTransport: self.webSocket)
    private(set) lazy var client = ApolloClient(networkTransport: self.splitNetworkTransport)
}


extension ErxesClient: HTTPNetworkTransportPreflightDelegate {
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        // If there's an authenticated user, send the request. If not, don't.
//        return UserManager.shared.hasAuthenticatedUser
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        
        // Get the existing headers, or create new ones if they're nil
        _ = request.allHTTPHeaderFields ?? [String: String]()
        
        // Add any new headers you need
//        headers["Authentication"] = "Bearer \(UserManager.shared.currentAuthToken)"
        
        // Re-assign the updated headers to the request.
//        request.headers = headers
        
//        Log.d("Outgoing request: \(request)")
    }
}


extension ErxesClient: HTTPNetworkTransportTaskCompletedDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          didCompleteRawTaskForRequest request: URLRequest,
                          withData data: Data?,
                          response: URLResponse?,
                          error: Error?) {
    
//        Log.d("Raw task completed for request: \(request)")
        if let error = error {
            Log.e("Error: \(error)")
        }
        
        if let response = response {
//            Log.d("Response: \(response)")
        } else {
            Log.e("No URL Response received!")
        }
        
        if let data = data {
//            Log.d("Data: \(String(describing: String(bytes: data, encoding: .utf8)))")
        } else {
            Log.e("No data received!")
        }
    }
}


