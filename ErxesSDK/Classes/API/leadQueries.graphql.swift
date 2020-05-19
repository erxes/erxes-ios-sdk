// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class FormDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query formDetail($_id: String!) {
      formDetail(_id: $_id) {
        __typename
        ...FormModel
      }
    }
    """

  public let operationName: String = "formDetail"

  public var queryDocument: String { return operationDefinition.appending(FormModel.fragmentDefinition).appending(FieldModel.fragmentDefinition) }

  public var _id: String

  public init(_id: String) {
    self._id = _id
  }

  public var variables: GraphQLMap? {
    return ["_id": _id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("formDetail", arguments: ["_id": GraphQLVariable("_id")], type: .object(FormDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(formDetail: FormDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "formDetail": formDetail.flatMap { (value: FormDetail) -> ResultMap in value.resultMap }])
    }

    public var formDetail: FormDetail? {
      get {
        return (resultMap["formDetail"] as? ResultMap).flatMap { FormDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "formDetail")
      }
    }

    public struct FormDetail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Form"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(FormModel.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var formModel: FormModel {
          get {
            return FormModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct FormModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment FormModel on Form {
      __typename
      title
      description
      buttonText
      fields {
        __typename
        ...FieldModel
      }
    }
    """

  public static let possibleTypes: [String] = ["Form"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("buttonText", type: .scalar(String.self)),
    GraphQLField("fields", type: .list(.object(Field.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(title: String? = nil, description: String? = nil, buttonText: String? = nil, fields: [Field?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Form", "title": title, "description": description, "buttonText": buttonText, "fields": fields.flatMap { (value: [Field?]) -> [ResultMap?] in value.map { (value: Field?) -> ResultMap? in value.flatMap { (value: Field) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var title: String? {
    get {
      return resultMap["title"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  public var buttonText: String? {
    get {
      return resultMap["buttonText"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "buttonText")
    }
  }

  public var fields: [Field?]? {
    get {
      return (resultMap["fields"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Field?] in value.map { (value: ResultMap?) -> Field? in value.flatMap { (value: ResultMap) -> Field in Field(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Field?]) -> [ResultMap?] in value.map { (value: Field?) -> ResultMap? in value.flatMap { (value: Field) -> ResultMap in value.resultMap } } }, forKey: "fields")
    }
  }

  public struct Field: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Field"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(FieldModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String, name: String? = nil, type: String? = nil, text: String? = nil, description: String? = nil, options: [String?]? = nil, isRequired: Bool? = nil, order: Int? = nil, validation: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Field", "_id": _id, "name": name, "type": type, "text": text, "description": description, "options": options, "isRequired": isRequired, "order": order, "validation": validation])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var fieldModel: FieldModel {
        get {
          return FieldModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct FieldModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment FieldModel on Field {
      __typename
      _id
      name
      type
      text
      description
      options
      isRequired
      order
      validation
    }
    """

  public static let possibleTypes: [String] = ["Field"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("type", type: .scalar(String.self)),
    GraphQLField("text", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("options", type: .list(.scalar(String.self))),
    GraphQLField("isRequired", type: .scalar(Bool.self)),
    GraphQLField("order", type: .scalar(Int.self)),
    GraphQLField("validation", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, name: String? = nil, type: String? = nil, text: String? = nil, description: String? = nil, options: [String?]? = nil, isRequired: Bool? = nil, order: Int? = nil, validation: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Field", "_id": _id, "name": name, "type": type, "text": text, "description": description, "options": options, "isRequired": isRequired, "order": order, "validation": validation])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var _id: String {
    get {
      return resultMap["_id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "_id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var type: String? {
    get {
      return resultMap["type"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }

  public var text: String? {
    get {
      return resultMap["text"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "text")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  public var options: [String?]? {
    get {
      return resultMap["options"] as? [String?]
    }
    set {
      resultMap.updateValue(newValue, forKey: "options")
    }
  }

  public var isRequired: Bool? {
    get {
      return resultMap["isRequired"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isRequired")
    }
  }

  public var order: Int? {
    get {
      return resultMap["order"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "order")
    }
  }

  public var validation: String? {
    get {
      return resultMap["validation"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "validation")
    }
  }
}
