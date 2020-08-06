// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class WidgetsMessengerSupportersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query widgetsMessengerSupporters($integrationId: String!) {
      widgetsMessengerSupporters(integrationId: $integrationId) {
        __typename
        isOnline
        serverTime
        supporters {
          __typename
          ...UserModel
        }
      }
    }
    """

  public let operationName: String = "widgetsMessengerSupporters"

  public var queryDocument: String { return operationDefinition.appending(UserModel.fragmentDefinition) }

  public var integrationId: String

  public init(integrationId: String) {
    self.integrationId = integrationId
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsMessengerSupporters", arguments: ["integrationId": GraphQLVariable("integrationId")], type: .object(WidgetsMessengerSupporter.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsMessengerSupporters: WidgetsMessengerSupporter? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsMessengerSupporters": widgetsMessengerSupporters.flatMap { (value: WidgetsMessengerSupporter) -> ResultMap in value.resultMap }])
    }

    public var widgetsMessengerSupporters: WidgetsMessengerSupporter? {
      get {
        return (resultMap["widgetsMessengerSupporters"] as? ResultMap).flatMap { WidgetsMessengerSupporter(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsMessengerSupporters")
      }
    }

    public struct WidgetsMessengerSupporter: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MessengerSupportersResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("isOnline", type: .scalar(Bool.self)),
        GraphQLField("serverTime", type: .scalar(String.self)),
        GraphQLField("supporters", type: .list(.object(Supporter.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(isOnline: Bool? = nil, serverTime: String? = nil, supporters: [Supporter?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "MessengerSupportersResponse", "isOnline": isOnline, "serverTime": serverTime, "supporters": supporters.flatMap { (value: [Supporter?]) -> [ResultMap?] in value.map { (value: Supporter?) -> ResultMap? in value.flatMap { (value: Supporter) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var isOnline: Bool? {
        get {
          return resultMap["isOnline"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isOnline")
        }
      }

      public var serverTime: String? {
        get {
          return resultMap["serverTime"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "serverTime")
        }
      }

      public var supporters: [Supporter?]? {
        get {
          return (resultMap["supporters"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Supporter?] in value.map { (value: ResultMap?) -> Supporter? in value.flatMap { (value: ResultMap) -> Supporter in Supporter(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Supporter?]) -> [ResultMap?] in value.map { (value: Supporter?) -> ResultMap? in value.flatMap { (value: Supporter) -> ResultMap in value.resultMap } } }, forKey: "supporters")
        }
      }

      public struct Supporter: GraphQLSelectionSet {
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
  }
}

public final class WidgetsTotalUnreadCountQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query widgetsTotalUnreadCount($integrationId: String!, $customerId: String!) {
      widgetsTotalUnreadCount(integrationId: $integrationId, customerId: $customerId)
    }
    """

  public let operationName: String = "widgetsTotalUnreadCount"

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
      GraphQLField("widgetsTotalUnreadCount", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId")], type: .scalar(Int.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsTotalUnreadCount: Int? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsTotalUnreadCount": widgetsTotalUnreadCount])
    }

    public var widgetsTotalUnreadCount: Int? {
      get {
        return resultMap["widgetsTotalUnreadCount"] as? Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "widgetsTotalUnreadCount")
      }
    }
  }
}

public final class WidgetsConversationsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query widgetsConversations($integrationId: String!, $customerId: String!) {
      widgetsConversations(integrationId: $integrationId, customerId: $customerId) {
        __typename
        ...ConversationModel
      }
    }
    """

  public let operationName: String = "widgetsConversations"

  public var queryDocument: String { return operationDefinition.appending(ConversationModel.fragmentDefinition).appending(UserModel.fragmentDefinition).appending(UserDetailModel.fragmentDefinition) }

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

public final class WidgetsConversationDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query widgetsConversationDetail($_id: String, $integrationId: String!) {
      widgetsConversationDetail(_id: $_id, integrationId: $integrationId) {
        __typename
        ...ConversationDetailModel
      }
    }
    """

  public let operationName: String = "widgetsConversationDetail"

  public var queryDocument: String { return operationDefinition.appending(ConversationDetailModel.fragmentDefinition).appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition).appending(UserDetailModel.fragmentDefinition) }

  public var _id: String?
  public var integrationId: String

  public init(_id: String? = nil, integrationId: String) {
    self._id = _id
    self.integrationId = integrationId
  }

  public var variables: GraphQLMap? {
    return ["_id": _id, "integrationId": integrationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsConversationDetail", arguments: ["_id": GraphQLVariable("_id"), "integrationId": GraphQLVariable("integrationId")], type: .object(WidgetsConversationDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsConversationDetail: WidgetsConversationDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsConversationDetail": widgetsConversationDetail.flatMap { (value: WidgetsConversationDetail) -> ResultMap in value.resultMap }])
    }

    public var widgetsConversationDetail: WidgetsConversationDetail? {
      get {
        return (resultMap["widgetsConversationDetail"] as? ResultMap).flatMap { WidgetsConversationDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsConversationDetail")
      }
    }

    public struct WidgetsConversationDetail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ConversationDetailResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ConversationDetailModel.self),
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

        public var conversationDetailModel: ConversationDetailModel {
          get {
            return ConversationDetailModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetConversationContentQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getConversationContent($conversationId: String!, $skip: Int, $limit: Int, $getFirst: Boolean) {
      conversationMessages(conversationId: $conversationId, skip: $skip, limit: $limit, getFirst: $getFirst) {
        __typename
        ...ConversationContent
      }
    }
    """

  public let operationName: String = "getConversationContent"

  public var queryDocument: String { return operationDefinition.appending(ConversationContent.fragmentDefinition) }

  public var conversationId: String
  public var skip: Int?
  public var limit: Int?
  public var getFirst: Bool?

  public init(conversationId: String, skip: Int? = nil, limit: Int? = nil, getFirst: Bool? = nil) {
    self.conversationId = conversationId
    self.skip = skip
    self.limit = limit
    self.getFirst = getFirst
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId, "skip": skip, "limit": limit, "getFirst": getFirst]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("conversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId"), "skip": GraphQLVariable("skip"), "limit": GraphQLVariable("limit"), "getFirst": GraphQLVariable("getFirst")], type: .list(.object(ConversationMessage.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(conversationMessages: [ConversationMessage?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "conversationMessages": conversationMessages.flatMap { (value: [ConversationMessage?]) -> [ResultMap?] in value.map { (value: ConversationMessage?) -> ResultMap? in value.flatMap { (value: ConversationMessage) -> ResultMap in value.resultMap } } }])
    }

    public var conversationMessages: [ConversationMessage?]? {
      get {
        return (resultMap["conversationMessages"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [ConversationMessage?] in value.map { (value: ResultMap?) -> ConversationMessage? in value.flatMap { (value: ResultMap) -> ConversationMessage in ConversationMessage(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [ConversationMessage?]) -> [ResultMap?] in value.map { (value: ConversationMessage?) -> ResultMap? in value.flatMap { (value: ConversationMessage) -> ResultMap in value.resultMap } } }, forKey: "conversationMessages")
      }
    }

    public struct ConversationMessage: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ConversationMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ConversationContent.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(_id: String, content: String? = nil, contentType: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": _id, "content": content, "contentType": contentType])
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

        public var conversationContent: ConversationContent {
          get {
            return ConversationContent(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class WidgetsUnreadCountQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query widgetsUnreadCount($conversationId: String) {
      widgetsUnreadCount(conversationId: $conversationId)
    }
    """

  public let operationName: String = "widgetsUnreadCount"

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

public struct UserModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserModel on User {
      __typename
      _id
      details {
        __typename
        avatar
        fullName
        shortName
      }
    }
    """

  public static let possibleTypes: [String] = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("details", type: .object(Detail.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, details: Detail? = nil) {
    self.init(unsafeResultMap: ["__typename": "User", "_id": _id, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }])
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

  public var details: Detail? {
    get {
      return (resultMap["details"] as? ResultMap).flatMap { Detail(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "details")
    }
  }

  public struct Detail: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["UserDetailsType"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("avatar", type: .scalar(String.self)),
      GraphQLField("fullName", type: .scalar(String.self)),
      GraphQLField("shortName", type: .scalar(String.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(avatar: String? = nil, fullName: String? = nil, shortName: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "UserDetailsType", "avatar": avatar, "fullName": fullName, "shortName": shortName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var avatar: String? {
      get {
        return resultMap["avatar"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "avatar")
      }
    }

    public var fullName: String? {
      get {
        return resultMap["fullName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "fullName")
      }
    }

    public var shortName: String? {
      get {
        return resultMap["shortName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "shortName")
      }
    }
  }
}

public struct UserDetailModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserDetailModel on User {
      __typename
      _id
      details {
        __typename
        avatar
        fullName
        shortName
        description
        position
      }
      links
    }
    """

  public static let possibleTypes: [String] = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("details", type: .object(Detail.selections)),
    GraphQLField("links", type: .scalar(Scalar_JSON.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, details: Detail? = nil, links: Scalar_JSON? = nil) {
    self.init(unsafeResultMap: ["__typename": "User", "_id": _id, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }, "links": links])
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

  public var details: Detail? {
    get {
      return (resultMap["details"] as? ResultMap).flatMap { Detail(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "details")
    }
  }

  public var links: Scalar_JSON? {
    get {
      return resultMap["links"] as? Scalar_JSON
    }
    set {
      resultMap.updateValue(newValue, forKey: "links")
    }
  }

  public struct Detail: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["UserDetailsType"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("avatar", type: .scalar(String.self)),
      GraphQLField("fullName", type: .scalar(String.self)),
      GraphQLField("shortName", type: .scalar(String.self)),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("position", type: .scalar(String.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(avatar: String? = nil, fullName: String? = nil, shortName: String? = nil, description: String? = nil, position: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "UserDetailsType", "avatar": avatar, "fullName": fullName, "shortName": shortName, "description": description, "position": position])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var avatar: String? {
      get {
        return resultMap["avatar"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "avatar")
      }
    }

    public var fullName: String? {
      get {
        return resultMap["fullName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "fullName")
      }
    }

    public var shortName: String? {
      get {
        return resultMap["shortName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "shortName")
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

    public var position: String? {
      get {
        return resultMap["position"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "position")
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
      assignedUser {
        __typename
        ...UserModel
      }
      participatedUsers {
        __typename
        ...UserDetailModel
      }
    }
    """

  public static let possibleTypes: [String] = ["Conversation"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("createdAt", type: .scalar(Scalar_Date.self)),
    GraphQLField("assignedUser", type: .object(AssignedUser.selections)),
    GraphQLField("participatedUsers", type: .list(.object(ParticipatedUser.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, content: String? = nil, createdAt: Scalar_Date? = nil, assignedUser: AssignedUser? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Conversation", "_id": _id, "content": content, "createdAt": createdAt, "assignedUser": assignedUser.flatMap { (value: AssignedUser) -> ResultMap in value.resultMap }, "participatedUsers": participatedUsers.flatMap { (value: [ParticipatedUser?]) -> [ResultMap?] in value.map { (value: ParticipatedUser?) -> ResultMap? in value.flatMap { (value: ParticipatedUser) -> ResultMap in value.resultMap } } }])
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

  public var assignedUser: AssignedUser? {
    get {
      return (resultMap["assignedUser"] as? ResultMap).flatMap { AssignedUser(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "assignedUser")
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

  public struct AssignedUser: GraphQLSelectionSet {
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

  public struct ParticipatedUser: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserDetailModel.self),
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

      public var userDetailModel: UserDetailModel {
        get {
          return UserDetailModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ConversationDetailModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConversationDetailModel on ConversationDetailResponse {
      __typename
      _id
      messages {
        __typename
        ...MessageModel
      }
      isOnline
      supporters {
        __typename
        ...UserModel
      }
      participatedUsers {
        __typename
        ...UserDetailModel
      }
    }
    """

  public static let possibleTypes: [String] = ["ConversationDetailResponse"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("messages", type: .list(.object(Message.selections))),
    GraphQLField("isOnline", type: .scalar(Bool.self)),
    GraphQLField("supporters", type: .list(.object(Supporter.selections))),
    GraphQLField("participatedUsers", type: .list(.object(ParticipatedUser.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String? = nil, messages: [Message?]? = nil, isOnline: Bool? = nil, supporters: [Supporter?]? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationDetailResponse", "_id": _id, "messages": messages.flatMap { (value: [Message?]) -> [ResultMap?] in value.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } } }, "isOnline": isOnline, "supporters": supporters.flatMap { (value: [Supporter?]) -> [ResultMap?] in value.map { (value: Supporter?) -> ResultMap? in value.flatMap { (value: Supporter) -> ResultMap in value.resultMap } } }, "participatedUsers": participatedUsers.flatMap { (value: [ParticipatedUser?]) -> [ResultMap?] in value.map { (value: ParticipatedUser?) -> ResultMap? in value.flatMap { (value: ParticipatedUser) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var _id: String? {
    get {
      return resultMap["_id"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "_id")
    }
  }

  public var messages: [Message?]? {
    get {
      return (resultMap["messages"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Message?] in value.map { (value: ResultMap?) -> Message? in value.flatMap { (value: ResultMap) -> Message in Message(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Message?]) -> [ResultMap?] in value.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } } }, forKey: "messages")
    }
  }

  public var isOnline: Bool? {
    get {
      return resultMap["isOnline"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isOnline")
    }
  }

  public var supporters: [Supporter?]? {
    get {
      return (resultMap["supporters"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Supporter?] in value.map { (value: ResultMap?) -> Supporter? in value.flatMap { (value: ResultMap) -> Supporter in Supporter(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Supporter?]) -> [ResultMap?] in value.map { (value: Supporter?) -> ResultMap? in value.flatMap { (value: Supporter) -> ResultMap in value.resultMap } } }, forKey: "supporters")
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

  public struct Message: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["ConversationMessage"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(MessageModel.self),
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

      public var messageModel: MessageModel {
        get {
          return MessageModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Supporter: GraphQLSelectionSet {
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

  public struct ParticipatedUser: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(UserDetailModel.self),
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

      public var userDetailModel: UserDetailModel {
        get {
          return UserDetailModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ConversationContent: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConversationContent on ConversationMessage {
      __typename
      _id
      content
      contentType
    }
    """

  public static let possibleTypes: [String] = ["ConversationMessage"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("contentType", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, content: String? = nil, contentType: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": _id, "content": content, "contentType": contentType])
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

  public var contentType: String? {
    get {
      return resultMap["contentType"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "contentType")
    }
  }
}
