// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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

      public init(customerId: String? = nil, unreadCount: Int? = nil) {
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
    GraphQLField("customerId", type: .scalar(String.self)),
    GraphQLField("unreadCount", type: .scalar(Int.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(customerId: String? = nil, unreadCount: Int? = nil) {
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

  public var customerId: String? {
    get {
      return resultMap["customerId"] as? String
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
