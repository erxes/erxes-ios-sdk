// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class WidgetsLeadConnectMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsLeadConnect($brandCode: String!, $formCode: String!) {
      widgetsLeadConnect(brandCode: $brandCode, formCode: $formCode) {
        __typename
        ...LeadResponseModel
      }
    }
    """

  public let operationName: String = "widgetsLeadConnect"

  public var queryDocument: String { return operationDefinition.appending("\n" + LeadResponseModel.fragmentDefinition) }

  public var brandCode: String
  public var formCode: String

  public init(brandCode: String, formCode: String) {
    self.brandCode = brandCode
    self.formCode = formCode
  }

  public var variables: GraphQLMap? {
    return ["brandCode": brandCode, "formCode": formCode]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsLeadConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "formCode": GraphQLVariable("formCode")], type: .object(WidgetsLeadConnect.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsLeadConnect: WidgetsLeadConnect? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsLeadConnect": widgetsLeadConnect.flatMap { (value: WidgetsLeadConnect) -> ResultMap in value.resultMap }])
    }

    public var widgetsLeadConnect: WidgetsLeadConnect? {
      get {
        return (resultMap["widgetsLeadConnect"] as? ResultMap).flatMap { WidgetsLeadConnect(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsLeadConnect")
      }
    }

    public struct WidgetsLeadConnect: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["FormConnectResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(LeadResponseModel.self),
        ]
      }

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

        public var leadResponseModel: LeadResponseModel {
          get {
            return LeadResponseModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class WidgetsSaveLeadMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsSaveLead($integrationId: String!, $formId: String!, $submissions: [FieldValueInput], $browserInfo: JSON!, $cachedCustomerId: String) {
      widgetsSaveLead(integrationId: $integrationId, formId: $formId, submissions: $submissions, browserInfo: $browserInfo, cachedCustomerId: $cachedCustomerId) {
        __typename
        ...FormResponseModel
      }
    }
    """

  public let operationName: String = "widgetsSaveLead"

  public var queryDocument: String { return operationDefinition.appending("\n" + FormResponseModel.fragmentDefinition).appending("\n" + FieldError.fragmentDefinition) }

  public var integrationId: String
  public var formId: String
  public var submissions: [FieldValueInput?]?
  public var browserInfo: Scalar_JSON
  public var cachedCustomerId: String?

  public init(integrationId: String, formId: String, submissions: [FieldValueInput?]? = nil, browserInfo: Scalar_JSON, cachedCustomerId: String? = nil) {
    self.integrationId = integrationId
    self.formId = formId
    self.submissions = submissions
    self.browserInfo = browserInfo
    self.cachedCustomerId = cachedCustomerId
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId, "formId": formId, "submissions": submissions, "browserInfo": browserInfo, "cachedCustomerId": cachedCustomerId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsSaveLead", arguments: ["integrationId": GraphQLVariable("integrationId"), "formId": GraphQLVariable("formId"), "submissions": GraphQLVariable("submissions"), "browserInfo": GraphQLVariable("browserInfo"), "cachedCustomerId": GraphQLVariable("cachedCustomerId")], type: .object(WidgetsSaveLead.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsSaveLead: WidgetsSaveLead? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsSaveLead": widgetsSaveLead.flatMap { (value: WidgetsSaveLead) -> ResultMap in value.resultMap }])
    }

    public var widgetsSaveLead: WidgetsSaveLead? {
      get {
        return (resultMap["widgetsSaveLead"] as? ResultMap).flatMap { WidgetsSaveLead(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsSaveLead")
      }
    }

    public struct WidgetsSaveLead: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SaveFormResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(FormResponseModel.self),
        ]
      }

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

        public var formResponseModel: FormResponseModel {
          get {
            return FormResponseModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct LeadResponseModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment LeadResponseModel on FormConnectResponse {
      __typename
      form {
        __typename
        _id
        title
        description
      }
      integration {
        __typename
        _id
        name
        leadData
      }
    }
    """

  public static let possibleTypes: [String] = ["FormConnectResponse"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("form", type: .object(Form.selections)),
      GraphQLField("integration", type: .object(Integration.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(form: Form? = nil, integration: Integration? = nil) {
    self.init(unsafeResultMap: ["__typename": "FormConnectResponse", "form": form.flatMap { (value: Form) -> ResultMap in value.resultMap }, "integration": integration.flatMap { (value: Integration) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var form: Form? {
    get {
      return (resultMap["form"] as? ResultMap).flatMap { Form(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "form")
    }
  }

  public var integration: Integration? {
    get {
      return (resultMap["integration"] as? ResultMap).flatMap { Integration(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "integration")
    }
  }

  public struct Form: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Form"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .scalar(String.self)),
        GraphQLField("description", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String, title: String? = nil, description: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Form", "_id": _id, "title": title, "description": description])
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
  }

  public struct Integration: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Integration"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("leadData", type: .scalar(Scalar_JSON.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String, name: String, leadData: Scalar_JSON? = nil) {
      self.init(unsafeResultMap: ["__typename": "Integration", "_id": _id, "name": name, "leadData": leadData])
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

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var leadData: Scalar_JSON? {
      get {
        return resultMap["leadData"] as? Scalar_JSON
      }
      set {
        resultMap.updateValue(newValue, forKey: "leadData")
      }
    }
  }
}

public struct FormResponseModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment FormResponseModel on SaveFormResponse {
      __typename
      status
      messageId
      errors {
        __typename
        ...FieldError
      }
    }
    """

  public static let possibleTypes: [String] = ["SaveFormResponse"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("status", type: .nonNull(.scalar(String.self))),
      GraphQLField("messageId", type: .scalar(String.self)),
      GraphQLField("errors", type: .list(.object(Error.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(status: String, messageId: String? = nil, errors: [Error?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "SaveFormResponse", "status": status, "messageId": messageId, "errors": errors.flatMap { (value: [Error?]) -> [ResultMap?] in value.map { (value: Error?) -> ResultMap? in value.flatMap { (value: Error) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var status: String {
    get {
      return resultMap["status"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "status")
    }
  }

  public var messageId: String? {
    get {
      return resultMap["messageId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "messageId")
    }
  }

  public var errors: [Error?]? {
    get {
      return (resultMap["errors"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Error?] in value.map { (value: ResultMap?) -> Error? in value.flatMap { (value: ResultMap) -> Error in Error(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Error?]) -> [ResultMap?] in value.map { (value: Error?) -> ResultMap? in value.flatMap { (value: Error) -> ResultMap in value.resultMap } } }, forKey: "errors")
    }
  }

  public struct Error: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Error"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(FieldError.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(fieldId: String? = nil, code: String? = nil, text: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Error", "fieldId": fieldId, "code": code, "text": text])
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

      public var fieldError: FieldError {
        get {
          return FieldError(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct FieldError: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment FieldError on Error {
      __typename
      fieldId
      code
      text
    }
    """

  public static let possibleTypes: [String] = ["Error"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("fieldId", type: .scalar(String.self)),
      GraphQLField("code", type: .scalar(String.self)),
      GraphQLField("text", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(fieldId: String? = nil, code: String? = nil, text: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Error", "fieldId": fieldId, "code": code, "text": text])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var fieldId: String? {
    get {
      return resultMap["fieldId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "fieldId")
    }
  }

  public var code: String? {
    get {
      return resultMap["code"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
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
}
