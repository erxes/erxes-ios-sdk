// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AllConversationsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AllConversations($integrationId: String!, $customerId: String!) {
      widgetsConversations(integrationId: $integrationId, customerId: $customerId) {
        __typename
        ...ConversationModel
      }
    }
    """

  public let operationName: String = "AllConversations"

  public var queryDocument: String { return operationDefinition.appending(ConversationModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }

  public var integrationId: String
  public var customerId: String

  public init(integrationId: String, customerId: String) {
    self.integrationId = integrationId
    self.customerId = customerId
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId, "customerId": customerId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsConversations", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId")], type: .list(.object(WidgetsConversation.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsConversations: [WidgetsConversation?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsConversations": widgetsConversations.flatMap { (value: [WidgetsConversation?]) -> [ResultMap?] in value.map { (value: WidgetsConversation?) -> ResultMap? in value.flatMap { (value: WidgetsConversation) -> ResultMap in value.resultMap } } }])
    }

    public var widgetsConversations: [WidgetsConversation?]? {
      get {
        return (resultMap["widgetsConversations"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [WidgetsConversation?] in value.map { (value: ResultMap?) -> WidgetsConversation? in value.flatMap { (value: ResultMap) -> WidgetsConversation in WidgetsConversation(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [WidgetsConversation?]) -> [ResultMap?] in value.map { (value: WidgetsConversation?) -> ResultMap? in value.flatMap { (value: WidgetsConversation) -> ResultMap in value.resultMap } } }, forKey: "widgetsConversations")
      }
    }

    public struct WidgetsConversation: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ConversationModel.self),
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

        public var conversationModel: ConversationModel {
          get {
            return ConversationModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class WidgetsLeadConnectMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsLeadConnect($brandCode: String!, $formCode: String!) {
      widgetsLeadConnect(brandCode: $brandCode, formCode: $formCode) {
        __typename
        ...FormConnectModel
      }
    }
    """

  public let operationName: String = "widgetsLeadConnect"

  public var queryDocument: String { return operationDefinition.appending(FormConnectModel.fragmentDefinition).appending(FormModel.fragmentDefinition).appending(IntegrationModel.fragmentDefinition) }

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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsLeadConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "formCode": GraphQLVariable("formCode")], type: .object(WidgetsLeadConnect.selections)),
    ]

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

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(FormConnectModel.self),
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

        public var formConnectModel: FormConnectModel {
          get {
            return FormConnectModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetMessengerIntegrationQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetMessengerIntegration($brandCode: String!) {
      widgetsGetMessengerIntegration(brandCode: $brandCode) {
        __typename
        _id
        languageCode
        uiOptions
        messengerData
        leadData
      }
    }
    """

  public let operationName: String = "GetMessengerIntegration"

  public var brandCode: String

  public init(brandCode: String) {
    self.brandCode = brandCode
  }

  public var variables: GraphQLMap? {
    return ["brandCode": brandCode]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsGetMessengerIntegration", arguments: ["brandCode": GraphQLVariable("brandCode")], type: .object(WidgetsGetMessengerIntegration.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsGetMessengerIntegration: WidgetsGetMessengerIntegration? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsGetMessengerIntegration": widgetsGetMessengerIntegration.flatMap { (value: WidgetsGetMessengerIntegration) -> ResultMap in value.resultMap }])
    }

    public var widgetsGetMessengerIntegration: WidgetsGetMessengerIntegration? {
      get {
        return (resultMap["widgetsGetMessengerIntegration"] as? ResultMap).flatMap { WidgetsGetMessengerIntegration(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsGetMessengerIntegration")
      }
    }

    public struct WidgetsGetMessengerIntegration: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Integration"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("languageCode", type: .scalar(String.self)),
        GraphQLField("uiOptions", type: .scalar(Scalar_JSON.self)),
        GraphQLField("messengerData", type: .scalar(Scalar_JSON.self)),
        GraphQLField("leadData", type: .scalar(Scalar_JSON.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(_id: String, languageCode: String? = nil, uiOptions: Scalar_JSON? = nil, messengerData: Scalar_JSON? = nil, leadData: Scalar_JSON? = nil) {
        self.init(unsafeResultMap: ["__typename": "Integration", "_id": _id, "languageCode": languageCode, "uiOptions": uiOptions, "messengerData": messengerData, "leadData": leadData])
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

      public var languageCode: String? {
        get {
          return resultMap["languageCode"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "languageCode")
        }
      }

      public var uiOptions: Scalar_JSON? {
        get {
          return resultMap["uiOptions"] as? Scalar_JSON
        }
        set {
          resultMap.updateValue(newValue, forKey: "uiOptions")
        }
      }

      public var messengerData: Scalar_JSON? {
        get {
          return resultMap["messengerData"] as? Scalar_JSON
        }
        set {
          resultMap.updateValue(newValue, forKey: "messengerData")
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
}

public final class UnreadCountQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query UnreadCount($conversationId: String) {
      widgetsUnreadCount(conversationId: $conversationId)
    }
    """

  public let operationName: String = "UnreadCount"

  public var conversationId: String?

  public init(conversationId: String? = nil) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsUnreadCount", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(Int.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsUnreadCount: Int? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsUnreadCount": widgetsUnreadCount])
    }

    public var widgetsUnreadCount: Int? {
      get {
        return resultMap["widgetsUnreadCount"] as? Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "widgetsUnreadCount")
      }
    }
  }
}

public struct ConversationModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConversationModel on Conversation {
      __typename
      _id
      content
      createdAt
      participatedUsers {
        __typename
        ...UserModel
      }
    }
    """

  public static let possibleTypes: [String] = ["Conversation"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("createdAt", type: .scalar(Scalar_Date.self)),
    GraphQLField("participatedUsers", type: .list(.object(ParticipatedUser.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, content: String? = nil, createdAt: Scalar_Date? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Conversation", "_id": _id, "content": content, "createdAt": createdAt, "participatedUsers": participatedUsers.flatMap { (value: [ParticipatedUser?]) -> [ResultMap?] in value.map { (value: ParticipatedUser?) -> ResultMap? in value.flatMap { (value: ParticipatedUser) -> ResultMap in value.resultMap } } }])
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

  public var content: String? {
    get {
      return resultMap["content"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: Scalar_Date? {
    get {
      return resultMap["createdAt"] as? Scalar_Date
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var participatedUsers: [ParticipatedUser?]? {
    get {
      return (resultMap["participatedUsers"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [ParticipatedUser?] in value.map { (value: ResultMap?) -> ParticipatedUser? in value.flatMap { (value: ResultMap) -> ParticipatedUser in ParticipatedUser(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [ParticipatedUser?]) -> [ResultMap?] in value.map { (value: ParticipatedUser?) -> ResultMap? in value.flatMap { (value: ParticipatedUser) -> ResultMap in value.resultMap } } }, forKey: "participatedUsers")
    }
  }

  public struct ParticipatedUser: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserModel.self),
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

      public var userModel: UserModel {
        get {
          return UserModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct FormConnectModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment FormConnectModel on FormConnectResponse {
      __typename
      form {
        __typename
        ...FormModel
      }
      integration {
        __typename
        ...IntegrationModel
      }
    }
    """

  public static let possibleTypes: [String] = ["FormConnectResponse"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("form", type: .object(Form.selections)),
    GraphQLField("integration", type: .object(Integration.selections)),
  ]

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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(FormModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String, title: String? = nil, description: String? = nil, buttonText: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Form", "_id": _id, "title": title, "description": description, "buttonText": buttonText])
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

  public struct Integration: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Integration"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(IntegrationModel.self),
    ]

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

      public var integrationModel: IntegrationModel {
        get {
          return IntegrationModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
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
      _id
      title
      description
      buttonText
    }
    """

  public static let possibleTypes: [String] = ["Form"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("buttonText", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, title: String? = nil, description: String? = nil, buttonText: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Form", "_id": _id, "title": title, "description": description, "buttonText": buttonText])
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

  public var buttonText: String? {
    get {
      return resultMap["buttonText"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "buttonText")
    }
  }
}

public struct IntegrationModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment IntegrationModel on Integration {
      __typename
      _id
      name
      leadData
    }
    """

  public static let possibleTypes: [String] = ["Integration"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("leadData", type: .scalar(Scalar_JSON.self)),
  ]

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
