
import UIKit
import Apollo

enum defs:String{
    case integrationId = "integrationId"
    case customerId = "customerId"
    case email = "email"
}

var apiUrl = ""
var subsUrl = ""

let apollo = ApolloClient(url: URL(string:apiUrl)!)
