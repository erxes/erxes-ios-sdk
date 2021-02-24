// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct FieldValueInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - _id
  ///   - type
  ///   - validation
  ///   - text
  ///   - value
  ///   - associatedFieldId
  public init(_id: String, type: Swift.Optional<String?> = nil, validation: Swift.Optional<String?> = nil, text: Swift.Optional<String?> = nil, value: Swift.Optional<String?> = nil, associatedFieldId: Swift.Optional<String?> = nil) {
    graphQLMap = ["_id": _id, "type": type, "validation": validation, "text": text, "value": value, "associatedFieldId": associatedFieldId]
  }

  public var _id: String {
    get {
      return graphQLMap["_id"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_id")
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

  public var validation: Swift.Optional<String?> {
    get {
      return graphQLMap["validation"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "validation")
    }
  }

  public var text: Swift.Optional<String?> {
    get {
      return graphQLMap["text"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "text")
    }
  }

  public var value: Swift.Optional<String?> {
    get {
      return graphQLMap["value"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "value")
    }
  }

  public var associatedFieldId: Swift.Optional<String?> {
    get {
      return graphQLMap["associatedFieldId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "associatedFieldId")
    }
  }
}

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
