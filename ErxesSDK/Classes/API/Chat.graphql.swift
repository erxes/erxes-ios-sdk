// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class InsertMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation InsertMessage($integrationId: String!, $customerId: String!, $conversationId: String, $message: String, $attachments: [AttachmentInput]) {
      widgetsInsertMessage(integrationId: $integrationId, customerId: $customerId, conversationId: $conversationId, message: $message, attachments: $attachments) {
        __typename
        ...MessageModel
      }
    }
    """

  public let operationName: String = "InsertMessage"

  public var queryDocument: String { return operationDefinition.appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }

  public var integrationId: String
  public var customerId: String
  public var conversationId: String?
  public var message: String?
  public var attachments: [AttachmentInput?]?

  public init(integrationId: String, customerId: String, conversationId: String? = nil, message: String? = nil, attachments: [AttachmentInput?]? = nil) {
    self.integrationId = integrationId
    self.customerId = customerId
    self.conversationId = conversationId
    self.message = message
    self.attachments = attachments
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId, "customerId": customerId, "conversationId": conversationId, "message": message, "attachments": attachments]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsInsertMessage", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId"), "conversationId": GraphQLVariable("conversationId"), "message": GraphQLVariable("message"), "attachments": GraphQLVariable("attachments")], type: .object(WidgetsInsertMessage.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsInsertMessage: WidgetsInsertMessage? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsInsertMessage": widgetsInsertMessage.flatMap { (value: WidgetsInsertMessage) -> ResultMap in value.resultMap }])
    }

    public var widgetsInsertMessage: WidgetsInsertMessage? {
      get {
        return (resultMap["widgetsInsertMessage"] as? ResultMap).flatMap { WidgetsInsertMessage(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsInsertMessage")
      }
    }

    public struct WidgetsInsertMessage: GraphQLSelectionSet {
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
  }
}

public final class MessagesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Messages($conversationId: String!) {
      widgetsMessages(conversationId: $conversationId) {
        __typename
        ...MessageModel
      }
    }
    """

  public let operationName: String = "Messages"

  public var queryDocument: String { return operationDefinition.appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .list(.object(WidgetsMessage.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsMessages: [WidgetsMessage?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsMessages": widgetsMessages.flatMap { (value: [WidgetsMessage?]) -> [ResultMap?] in value.map { (value: WidgetsMessage?) -> ResultMap? in value.flatMap { (value: WidgetsMessage) -> ResultMap in value.resultMap } } }])
    }

    public var widgetsMessages: [WidgetsMessage?]? {
      get {
        return (resultMap["widgetsMessages"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [WidgetsMessage?] in value.map { (value: ResultMap?) -> WidgetsMessage? in value.flatMap { (value: ResultMap) -> WidgetsMessage in WidgetsMessage(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [WidgetsMessage?]) -> [ResultMap?] in value.map { (value: WidgetsMessage?) -> ResultMap? in value.flatMap { (value: WidgetsMessage) -> ResultMap in value.resultMap } } }, forKey: "widgetsMessages")
      }
    }

    public struct WidgetsMessage: GraphQLSelectionSet {
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
  }
}

public final class ConversationDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ConversationDetail($id: String, $integrationId: String!) {
      widgetsConversationDetail(_id: $id, integrationId: $integrationId) {
        __typename
        ...DetailResponse
      }
    }
    """

  public let operationName: String = "ConversationDetail"

  public var queryDocument: String { return operationDefinition.appending(DetailResponse.fragmentDefinition) }

  public var id: String?
  public var integrationId: String

  public init(id: String? = nil, integrationId: String) {
    self.id = id
    self.integrationId = integrationId
  }

  public var variables: GraphQLMap? {
    return ["id": id, "integrationId": integrationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsConversationDetail", arguments: ["_id": GraphQLVariable("id"), "integrationId": GraphQLVariable("integrationId")], type: .object(WidgetsConversationDetail.selections)),
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
        GraphQLFragmentSpread(DetailResponse.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(isOnline: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "ConversationDetailResponse", "isOnline": isOnline])
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

        public var detailResponse: DetailResponse {
          get {
            return DetailResponse(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ReadConversationMessagesMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation ReadConversationMessages($conversationId: String!) {
      widgetsReadConversationMessages(conversationId: $conversationId)
    }
    """

  public let operationName: String = "ReadConversationMessages"

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsReadConversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(Scalar_JSON.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsReadConversationMessages: Scalar_JSON? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsReadConversationMessages": widgetsReadConversationMessages])
    }

    public var widgetsReadConversationMessages: Scalar_JSON? {
      get {
        return resultMap["widgetsReadConversationMessages"] as? Scalar_JSON
      }
      set {
        resultMap.updateValue(newValue, forKey: "widgetsReadConversationMessages")
      }
    }
  }
}

public final class ConversationMessageInsertedSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription conversationMessageInserted($id: String!) {
      conversationMessageInserted(_id: $id) {
        __typename
        ...MessageModel
      }
    }
    """

  public let operationName: String = "conversationMessageInserted"

  public var queryDocument: String { return operationDefinition.appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("conversationMessageInserted", arguments: ["_id": GraphQLVariable("id")], type: .object(ConversationMessageInserted.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(conversationMessageInserted: ConversationMessageInserted? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "conversationMessageInserted": conversationMessageInserted.flatMap { (value: ConversationMessageInserted) -> ResultMap in value.resultMap }])
    }

    public var conversationMessageInserted: ConversationMessageInserted? {
      get {
        return (resultMap["conversationMessageInserted"] as? ResultMap).flatMap { ConversationMessageInserted(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "conversationMessageInserted")
      }
    }

    public struct ConversationMessageInserted: GraphQLSelectionSet {
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
  }
}

public final class ConversationAdminMessageInsertedSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription conversationAdminMessageInserted($customerId: String!) {
      conversationAdminMessageInserted(customerId: $customerId) {
        __typename
        ...ConversationAdminMessageInsertedModel
      }
    }
    """

  public let operationName: String = "conversationAdminMessageInserted"

  public var queryDocument: String { return operationDefinition.appending(ConversationAdminMessageInsertedModel.fragmentDefinition) }

  public var customerId: String

  public init(customerId: String) {
    self.customerId = customerId
  }

  public var variables: GraphQLMap? {
    return ["customerId": customerId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("conversationAdminMessageInserted", arguments: ["customerId": GraphQLVariable("customerId")], type: .object(ConversationAdminMessageInserted.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(conversationAdminMessageInserted: ConversationAdminMessageInserted? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "conversationAdminMessageInserted": conversationAdminMessageInserted.flatMap { (value: ConversationAdminMessageInserted) -> ResultMap in value.resultMap }])
    }

    public var conversationAdminMessageInserted: ConversationAdminMessageInserted? {
      get {
        return (resultMap["conversationAdminMessageInserted"] as? ResultMap).flatMap { ConversationAdminMessageInserted(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "conversationAdminMessageInserted")
      }
    }

    public struct ConversationAdminMessageInserted: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ConversationAdminMessageInsertedResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ConversationAdminMessageInsertedModel.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(customerId: String, unreadCount: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "ConversationAdminMessageInsertedResponse", "customerId": customerId, "unreadCount": unreadCount])
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

        public var conversationAdminMessageInsertedModel: ConversationAdminMessageInsertedModel {
          get {
            return ConversationAdminMessageInsertedModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct DetailResponse: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment DetailResponse on ConversationDetailResponse {
      __typename
      isOnline
    }
    """

  public static let possibleTypes: [String] = ["ConversationDetailResponse"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("isOnline", type: .scalar(Bool.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(isOnline: Bool? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationDetailResponse", "isOnline": isOnline])
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
}

public struct MessageModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MessageModel on ConversationMessage {
      __typename
      _id
      conversationId
      user {
        __typename
        ...UserModel
      }
      customerId
      content
      createdAt
      attachments {
        __typename
        url
        name
        type
        size
      }
    }
    """

  public static let possibleTypes: [String] = ["ConversationMessage"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("conversationId", type: .scalar(String.self)),
    GraphQLField("user", type: .object(User.selections)),
    GraphQLField("customerId", type: .scalar(String.self)),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("createdAt", type: .scalar(Scalar_Date.self)),
    GraphQLField("attachments", type: .list(.object(Attachment.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, conversationId: String? = nil, user: User? = nil, customerId: String? = nil, content: String? = nil, createdAt: Scalar_Date? = nil, attachments: [Attachment?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": _id, "conversationId": conversationId, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "customerId": customerId, "content": content, "createdAt": createdAt, "attachments": attachments.flatMap { (value: [Attachment?]) -> [ResultMap?] in value.map { (value: Attachment?) -> ResultMap? in value.flatMap { (value: Attachment) -> ResultMap in value.resultMap } } }])
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

  public var conversationId: String? {
    get {
      return resultMap["conversationId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "conversationId")
    }
  }

  public var user: User? {
    get {
      return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "user")
    }
  }

  public var customerId: String? {
    get {
      return resultMap["customerId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "customerId")
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

  public var attachments: [Attachment?]? {
    get {
      return (resultMap["attachments"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Attachment?] in value.map { (value: ResultMap?) -> Attachment? in value.flatMap { (value: ResultMap) -> Attachment in Attachment(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Attachment?]) -> [ResultMap?] in value.map { (value: Attachment?) -> ResultMap? in value.flatMap { (value: Attachment) -> ResultMap in value.resultMap } } }, forKey: "attachments")
    }
  }

  public struct User: GraphQLSelectionSet {
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

  public struct Attachment: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Attachment"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("url", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("type", type: .nonNull(.scalar(String.self))),
      GraphQLField("size", type: .scalar(Double.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(url: String, name: String? = nil, type: String, size: Double? = nil) {
      self.init(unsafeResultMap: ["__typename": "Attachment", "url": url, "name": name, "type": type, "size": size])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var url: String {
      get {
        return resultMap["url"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "url")
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

    public var type: String {
      get {
        return resultMap["type"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "type")
      }
    }

    public var size: Double? {
      get {
        return resultMap["size"] as? Double
      }
      set {
        resultMap.updateValue(newValue, forKey: "size")
      }
    }
  }
}

public struct AttachmentModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AttachmentModel on Attachment {
      __typename
      url
      name
      type
      size
    }
    """

  public static let possibleTypes: [String] = ["Attachment"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("type", type: .nonNull(.scalar(String.self))),
    GraphQLField("size", type: .scalar(Double.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(url: String, name: String? = nil, type: String, size: Double? = nil) {
    self.init(unsafeResultMap: ["__typename": "Attachment", "url": url, "name": name, "type": type, "size": size])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var url: String {
    get {
      return resultMap["url"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "url")
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

  public var type: String {
    get {
      return resultMap["type"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }

  public var size: Double? {
    get {
      return resultMap["size"] as? Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct ConversationAdminMessageInsertedModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConversationAdminMessageInsertedModel on ConversationAdminMessageInsertedResponse {
      __typename
      customerId
      unreadCount
    }
    """

  public static let possibleTypes: [String] = ["ConversationAdminMessageInsertedResponse"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("customerId", type: .nonNull(.scalar(String.self))),
    GraphQLField("unreadCount", type: .scalar(Int.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(customerId: String, unreadCount: Int? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationAdminMessageInsertedResponse", "customerId": customerId, "unreadCount": unreadCount])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var customerId: String {
    get {
      return resultMap["customerId"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "customerId")
    }
  }

  public var unreadCount: Int? {
    get {
      return resultMap["unreadCount"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "unreadCount")
    }
  }
}
