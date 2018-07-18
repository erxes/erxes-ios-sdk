
import UIKit
import Apollo

enum defs:String {
    case integrationId = "integrationId"
    case customerId = "customerId"
    case email = "email"
}

var apiUrl = ""
var subsUrl = ""

let apollo = ApolloClient(url: URL(string:apiUrl)!)

public typealias JSON = [String:Any?]

extension Dictionary: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {
        guard let dictionary = value as? Dictionary else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Dictionary.self)
        }
        self = dictionary
    }
}
