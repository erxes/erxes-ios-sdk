
import UIKit
import Apollo

enum defs:String {
    case integrationId = "integrationId"
    case customerId = "customerId"
    case email = "email"
}

var apiUrl = ""
var subsUrl = ""
var uploadUrl = ""

let apollo = ApolloClient(url: URL(string:apiUrl)!)

public typealias Scalar_JSON = [String: Any]
public typealias Scalar_Date = Int64

extension Int64: JSONDecodable, JSONEncodable {
    public init(jsonValue value: JSONValue) throws {
        
        let string = String(describing: value)
        guard let number = Int64(string) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Int64.self)
        }
        
        self = number
    }
    
    public var jsonValue: JSONValue {
        return String(self)
    }
}

extension Dictionary: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {
        guard let dictionary = value as? Dictionary else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Dictionary.self)
        }
        
        self = dictionary
    }
}
