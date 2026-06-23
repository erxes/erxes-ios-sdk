// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct AttachmentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - url
  ///   - name
  ///   - type
  ///   - size
  public init(url: String, name: String, type: Swift.Optional<String?> = nil, size: Swift.Optional<Double?> = nil) {
    graphQLMap = ["url": url, "name": name, "type": type, "size": size]
  }

  public var url: String {
    get {
      return graphQLMap["url"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var type: Swift.Optional<String?> {
    get {
      return graphQLMap["type"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var size: Swift.Optional<Double?> {
    get {
      return graphQLMap["size"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}
