
import UIKit
import Apollo

enum defs:String{
    case integrationId = "integrationId"
    case customerId = "customerId"
    case email = "email"
}

let host = "192.168.86.247"
let apiUrl = "http://\(host):3100/graphql"
let subsUrl = "ws://\(host):3300/subscriptions"

let apollo = ApolloClient(url: URL(string:apiUrl)!)
