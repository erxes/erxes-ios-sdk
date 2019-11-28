//  This file was automatically generated and should not be edited.

import Apollo

public struct AttachmentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(url: String, name: String, type: String, size: Swift.Optional<Double?> = nil) {
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

  public var type: String {
    get {
      return graphQLMap["type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var size: Swift.Optional<Double?> {
    get {
      return graphQLMap["size"] as? Swift.Optional<Double?> ?? .none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public final class InsertMessageMutation: GraphQLMutation {
  /// mutation insertMessage($integrationId: String!, $customerId: String!, $conversationId: String, $message: String, $attachments: [AttachmentInput]) {
  ///   insertMessage(integrationId: $integrationId, customerId: $customerId, conversationId: $conversationId, message: $message, attachments: $attachments) {
  ///     __typename
  ///     ...MessageModel
  ///   }
  /// }
  public let operationDefinition =
    "mutation insertMessage($integrationId: String!, $customerId: String!, $conversationId: String, $message: String, $attachments: [AttachmentInput]) { insertMessage(integrationId: $integrationId, customerId: $customerId, conversationId: $conversationId, message: $message, attachments: $attachments) { __typename ...MessageModel } }"

  public let operationName = "insertMessage"

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
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("insertMessage", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId"), "conversationId": GraphQLVariable("conversationId"), "message": GraphQLVariable("message"), "attachments": GraphQLVariable("attachments")], type: .object(InsertMessage.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(insertMessage: InsertMessage? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "insertMessage": insertMessage.flatMap { (value: InsertMessage) -> ResultMap in value.resultMap }])
    }

    public var insertMessage: InsertMessage? {
      get {
        return (resultMap["insertMessage"] as? ResultMap).flatMap { InsertMessage(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "insertMessage")
      }
    }

    public struct InsertMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationMessage"]

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
  /// query Messages($conversationId: String!) {
  ///   messages(conversationId: $conversationId) {
  ///     __typename
  ///     ...MessageModel
  ///   }
  /// }
  public let operationDefinition =
    "query Messages($conversationId: String!) { messages(conversationId: $conversationId) { __typename ...MessageModel } }"

  public let operationName = "Messages"

  public var queryDocument: String { return operationDefinition.appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .list(.object(Message.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(messages: [Message?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "messages": messages.flatMap { (value: [Message?]) -> [ResultMap?] in value.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } } }])
    }

    public var messages: [Message?]? {
      get {
        return (resultMap["messages"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Message?] in value.map { (value: ResultMap?) -> Message? in value.flatMap { (value: ResultMap) -> Message in Message(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Message?]) -> [ResultMap?] in value.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } } }, forKey: "messages")
      }
    }

    public struct Message: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationMessage"]

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
  /// query conversationDetail($id: String, $integrationId: String!) {
  ///   conversationDetail(_id: $id, integrationId: $integrationId) {
  ///     __typename
  ///     ...DetailResponse
  ///   }
  /// }
  public let operationDefinition =
    "query conversationDetail($id: String, $integrationId: String!) { conversationDetail(_id: $id, integrationId: $integrationId) { __typename ...DetailResponse } }"

  public let operationName = "conversationDetail"

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
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("conversationDetail", arguments: ["_id": GraphQLVariable("id"), "integrationId": GraphQLVariable("integrationId")], type: .object(ConversationDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(conversationDetail: ConversationDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "conversationDetail": conversationDetail.flatMap { (value: ConversationDetail) -> ResultMap in value.resultMap }])
    }

    public var conversationDetail: ConversationDetail? {
      get {
        return (resultMap["conversationDetail"] as? ResultMap).flatMap { ConversationDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "conversationDetail")
      }
    }

    public struct ConversationDetail: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationDetailResponse"]

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
  /// mutation readConversationMessages($conversationId: String!) {
  ///   readConversationMessages(conversationId: $conversationId)
  /// }
  public let operationDefinition =
    "mutation readConversationMessages($conversationId: String!) { readConversationMessages(conversationId: $conversationId) }"

  public let operationName = "readConversationMessages"

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("readConversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(Scalar_JSON.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(readConversationMessages: Scalar_JSON? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "readConversationMessages": readConversationMessages])
    }

    public var readConversationMessages: Scalar_JSON? {
      get {
        return resultMap["readConversationMessages"] as? Scalar_JSON
      }
      set {
        resultMap.updateValue(newValue, forKey: "readConversationMessages")
      }
    }
  }
}

public final class MessengerSupportersQuery: GraphQLQuery {
  /// query messengerSupporters($integrationId: String!) {
  ///   messengerSupporters(integrationId: $integrationId) {
  ///     __typename
  ///     ...UserModel
  ///   }
  /// }
  public let operationDefinition =
    "query messengerSupporters($integrationId: String!) { messengerSupporters(integrationId: $integrationId) { __typename ...UserModel } }"

  public let operationName = "messengerSupporters"

  public var queryDocument: String { return operationDefinition.appending(UserModel.fragmentDefinition) }

  public var integrationId: String

  public init(integrationId: String) {
    self.integrationId = integrationId
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messengerSupporters", arguments: ["integrationId": GraphQLVariable("integrationId")], type: .list(.object(MessengerSupporter.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(messengerSupporters: [MessengerSupporter?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "messengerSupporters": messengerSupporters.flatMap { (value: [MessengerSupporter?]) -> [ResultMap?] in value.map { (value: MessengerSupporter?) -> ResultMap? in value.flatMap { (value: MessengerSupporter) -> ResultMap in value.resultMap } } }])
    }

    public var messengerSupporters: [MessengerSupporter?]? {
      get {
        return (resultMap["messengerSupporters"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MessengerSupporter?] in value.map { (value: ResultMap?) -> MessengerSupporter? in value.flatMap { (value: ResultMap) -> MessengerSupporter in MessengerSupporter(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [MessengerSupporter?]) -> [ResultMap?] in value.map { (value: MessengerSupporter?) -> ResultMap? in value.flatMap { (value: MessengerSupporter) -> ResultMap in value.resultMap } } }, forKey: "messengerSupporters")
      }
    }

    public struct MessengerSupporter: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

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

public final class AllConversationsQuery: GraphQLQuery {
  /// query allConversations($integrationId: String!, $customerId: String!) {
  ///   conversations(integrationId: $integrationId, customerId: $customerId) {
  ///     __typename
  ///     ...ConversationModel
  ///   }
  /// }
  public let operationDefinition =
    "query allConversations($integrationId: String!, $customerId: String!) { conversations(integrationId: $integrationId, customerId: $customerId) { __typename ...ConversationModel } }"

  public let operationName = "allConversations"

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
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("conversations", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId")], type: .list(.object(Conversation.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(conversations: [Conversation?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "conversations": conversations.flatMap { (value: [Conversation?]) -> [ResultMap?] in value.map { (value: Conversation?) -> ResultMap? in value.flatMap { (value: Conversation) -> ResultMap in value.resultMap } } }])
    }

    public var conversations: [Conversation?]? {
      get {
        return (resultMap["conversations"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Conversation?] in value.map { (value: ResultMap?) -> Conversation? in value.flatMap { (value: ResultMap) -> Conversation in Conversation(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Conversation?]) -> [ResultMap?] in value.map { (value: Conversation?) -> ResultMap? in value.flatMap { (value: Conversation) -> ResultMap in value.resultMap } } }, forKey: "conversations")
      }
    }

    public struct Conversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

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

public final class FormConnectMutation: GraphQLMutation {
  /// mutation formConnect($brandCode: String!, $formCode: String!) {
  ///   leadConnect(brandCode: $brandCode, formCode: $formCode) {
  ///     __typename
  ///     ...FormConnectModel
  ///   }
  /// }
  public let operationDefinition =
    "mutation formConnect($brandCode: String!, $formCode: String!) { leadConnect(brandCode: $brandCode, formCode: $formCode) { __typename ...FormConnectModel } }"

  public let operationName = "formConnect"

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
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("leadConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "formCode": GraphQLVariable("formCode")], type: .object(LeadConnect.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(leadConnect: LeadConnect? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "leadConnect": leadConnect.flatMap { (value: LeadConnect) -> ResultMap in value.resultMap }])
    }

    public var leadConnect: LeadConnect? {
      get {
        return (resultMap["leadConnect"] as? ResultMap).flatMap { LeadConnect(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "leadConnect")
      }
    }

    public struct LeadConnect: GraphQLSelectionSet {
      public static let possibleTypes = ["FormConnectResponse"]

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
  /// query getMessengerIntegration($brandCode: String!) {
  ///   getMessengerIntegration(brandCode: $brandCode) {
  ///     __typename
  ///     _id
  ///     languageCode
  ///     uiOptions
  ///     messengerData
  ///     leadData
  ///   }
  /// }
  public let operationDefinition =
    "query getMessengerIntegration($brandCode: String!) { getMessengerIntegration(brandCode: $brandCode) { __typename _id languageCode uiOptions messengerData leadData } }"

  public let operationName = "getMessengerIntegration"

  public var brandCode: String

  public init(brandCode: String) {
    self.brandCode = brandCode
  }

  public var variables: GraphQLMap? {
    return ["brandCode": brandCode]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getMessengerIntegration", arguments: ["brandCode": GraphQLVariable("brandCode")], type: .object(GetMessengerIntegration.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getMessengerIntegration: GetMessengerIntegration? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getMessengerIntegration": getMessengerIntegration.flatMap { (value: GetMessengerIntegration) -> ResultMap in value.resultMap }])
    }

    public var getMessengerIntegration: GetMessengerIntegration? {
      get {
        return (resultMap["getMessengerIntegration"] as? ResultMap).flatMap { GetMessengerIntegration(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "getMessengerIntegration")
      }
    }

    public struct GetMessengerIntegration: GraphQLSelectionSet {
      public static let possibleTypes = ["Integration"]

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

      public init(id: String, languageCode: String? = nil, uiOptions: Scalar_JSON? = nil, messengerData: Scalar_JSON? = nil, leadData: Scalar_JSON? = nil) {
        self.init(unsafeResultMap: ["__typename": "Integration", "_id": id, "languageCode": languageCode, "uiOptions": uiOptions, "messengerData": messengerData, "leadData": leadData])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
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
  /// query unreadCount($conversationId: String) {
  ///   unreadCount(conversationId: $conversationId)
  /// }
  public let operationDefinition =
    "query unreadCount($conversationId: String) { unreadCount(conversationId: $conversationId) }"

  public let operationName = "unreadCount"

  public var conversationId: String?

  public init(conversationId: String? = nil) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("unreadCount", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(Int.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(unreadCount: Int? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "unreadCount": unreadCount])
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
}

public final class KnowledgeBaseTopicsDetailQuery: GraphQLQuery {
  /// query knowledgeBaseTopicsDetail($topicId: String!) {
  ///   knowledgeBaseTopicsDetail(topicId: $topicId) {
  ///     __typename
  ///     ...KnowledgeBaseTopicModel
  ///   }
  /// }
  public let operationDefinition =
    "query knowledgeBaseTopicsDetail($topicId: String!) { knowledgeBaseTopicsDetail(topicId: $topicId) { __typename ...KnowledgeBaseTopicModel } }"

  public let operationName = "knowledgeBaseTopicsDetail"

  public var queryDocument: String { return operationDefinition.appending(KnowledgeBaseTopicModel.fragmentDefinition).appending(KnowledgeBaseCategoryModel.fragmentDefinition).appending(KbArticleModel.fragmentDefinition) }

  public var topicId: String

  public init(topicId: String) {
    self.topicId = topicId
  }

  public var variables: GraphQLMap? {
    return ["topicId": topicId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("knowledgeBaseTopicsDetail", arguments: ["topicId": GraphQLVariable("topicId")], type: .object(KnowledgeBaseTopicsDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(knowledgeBaseTopicsDetail: KnowledgeBaseTopicsDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "knowledgeBaseTopicsDetail": knowledgeBaseTopicsDetail.flatMap { (value: KnowledgeBaseTopicsDetail) -> ResultMap in value.resultMap }])
    }

    public var knowledgeBaseTopicsDetail: KnowledgeBaseTopicsDetail? {
      get {
        return (resultMap["knowledgeBaseTopicsDetail"] as? ResultMap).flatMap { KnowledgeBaseTopicsDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "knowledgeBaseTopicsDetail")
      }
    }

    public struct KnowledgeBaseTopicsDetail: GraphQLSelectionSet {
      public static let possibleTypes = ["KnowledgeBaseTopic"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(KnowledgeBaseTopicModel.self),
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

        public var knowledgeBaseTopicModel: KnowledgeBaseTopicModel {
          get {
            return KnowledgeBaseTopicModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MessengerConnectMutation: GraphQLMutation {
  /// mutation messengerConnect($brandCode: String!, $email: String, $phone: String, $isUser: Boolean, $data: JSON, $companyData: JSON, $cachedCustomerId: String, $deviceToken: String) {
  ///   messengerConnect(brandCode: $brandCode, email: $email, phone: $phone, isUser: $isUser, data: $data, companyData: $companyData, deviceToken: $deviceToken, cachedCustomerId: $cachedCustomerId) {
  ///     __typename
  ///     ...ConnectResponseModel
  ///   }
  /// }
  public let operationDefinition =
    "mutation messengerConnect($brandCode: String!, $email: String, $phone: String, $isUser: Boolean, $data: JSON, $companyData: JSON, $cachedCustomerId: String, $deviceToken: String) { messengerConnect(brandCode: $brandCode, email: $email, phone: $phone, isUser: $isUser, data: $data, companyData: $companyData, deviceToken: $deviceToken, cachedCustomerId: $cachedCustomerId) { __typename ...ConnectResponseModel } }"

  public let operationName = "messengerConnect"

  public var queryDocument: String { return operationDefinition.appending(ConnectResponseModel.fragmentDefinition).appending(BrandModel.fragmentDefinition) }

  public var brandCode: String
  public var email: String?
  public var phone: String?
  public var isUser: Bool?
  public var data: Scalar_JSON?
  public var companyData: Scalar_JSON?
  public var cachedCustomerId: String?
  public var deviceToken: String?

  public init(brandCode: String, email: String? = nil, phone: String? = nil, isUser: Bool? = nil, data: Scalar_JSON? = nil, companyData: Scalar_JSON? = nil, cachedCustomerId: String? = nil, deviceToken: String? = nil) {
    self.brandCode = brandCode
    self.email = email
    self.phone = phone
    self.isUser = isUser
    self.data = data
    self.companyData = companyData
    self.cachedCustomerId = cachedCustomerId
    self.deviceToken = deviceToken
  }

  public var variables: GraphQLMap? {
    return ["brandCode": brandCode, "email": email, "phone": phone, "isUser": isUser, "data": data, "companyData": companyData, "cachedCustomerId": cachedCustomerId, "deviceToken": deviceToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messengerConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "email": GraphQLVariable("email"), "phone": GraphQLVariable("phone"), "isUser": GraphQLVariable("isUser"), "data": GraphQLVariable("data"), "companyData": GraphQLVariable("companyData"), "deviceToken": GraphQLVariable("deviceToken"), "cachedCustomerId": GraphQLVariable("cachedCustomerId")], type: .object(MessengerConnect.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(messengerConnect: MessengerConnect? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "messengerConnect": messengerConnect.flatMap { (value: MessengerConnect) -> ResultMap in value.resultMap }])
    }

    public var messengerConnect: MessengerConnect? {
      get {
        return (resultMap["messengerConnect"] as? ResultMap).flatMap { MessengerConnect(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "messengerConnect")
      }
    }

    public struct MessengerConnect: GraphQLSelectionSet {
      public static let possibleTypes = ["MessengerConnectResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ConnectResponseModel.self),
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

        public var connectResponseModel: ConnectResponseModel {
          get {
            return ConnectResponseModel(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class KnowledgeBaseCategoriesDetailQuery: GraphQLQuery {
  /// query knowledgeBaseCategoriesDetail($categoryId: String!) {
  ///   knowledgeBaseCategoriesDetail(categoryId: $categoryId) {
  ///     __typename
  ///     ...KBModel
  ///   }
  /// }
  public let operationDefinition =
    "query knowledgeBaseCategoriesDetail($categoryId: String!) { knowledgeBaseCategoriesDetail(categoryId: $categoryId) { __typename ...KBModel } }"

  public let operationName = "knowledgeBaseCategoriesDetail"

  public var queryDocument: String { return operationDefinition.appending(KbModel.fragmentDefinition).appending(KbArticleModel.fragmentDefinition) }

  public var categoryId: String

  public init(categoryId: String) {
    self.categoryId = categoryId
  }

  public var variables: GraphQLMap? {
    return ["categoryId": categoryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("knowledgeBaseCategoriesDetail", arguments: ["categoryId": GraphQLVariable("categoryId")], type: .object(KnowledgeBaseCategoriesDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(knowledgeBaseCategoriesDetail: KnowledgeBaseCategoriesDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "knowledgeBaseCategoriesDetail": knowledgeBaseCategoriesDetail.flatMap { (value: KnowledgeBaseCategoriesDetail) -> ResultMap in value.resultMap }])
    }

    public var knowledgeBaseCategoriesDetail: KnowledgeBaseCategoriesDetail? {
      get {
        return (resultMap["knowledgeBaseCategoriesDetail"] as? ResultMap).flatMap { KnowledgeBaseCategoriesDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "knowledgeBaseCategoriesDetail")
      }
    }

    public struct KnowledgeBaseCategoriesDetail: GraphQLSelectionSet {
      public static let possibleTypes = ["KnowledgeBaseCategory"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(KbModel.self),
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

        public var kbModel: KbModel {
          get {
            return KbModel(unsafeResultMap: resultMap)
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
  /// fragment DetailResponse on ConversationDetailResponse {
  ///   __typename
  ///   isOnline
  /// }
  public static let fragmentDefinition =
    "fragment DetailResponse on ConversationDetailResponse { __typename isOnline }"

  public static let possibleTypes = ["ConversationDetailResponse"]

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
  /// fragment MessageModel on ConversationMessage {
  ///   __typename
  ///   _id
  ///   conversationId
  ///   user {
  ///     __typename
  ///     ...UserModel
  ///   }
  ///   customerId
  ///   content
  ///   createdAt
  ///   attachments {
  ///     __typename
  ///     url
  ///     name
  ///     type
  ///     size
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment MessageModel on ConversationMessage { __typename _id conversationId user { __typename ...UserModel } customerId content createdAt attachments { __typename url name type size } }"

  public static let possibleTypes = ["ConversationMessage"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("conversationId", type: .nonNull(.scalar(String.self))),
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

  public init(id: String, conversationId: String, user: User? = nil, customerId: String? = nil, content: String? = nil, createdAt: Scalar_Date? = nil, attachments: [Attachment?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": id, "conversationId": conversationId, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "customerId": customerId, "content": content, "createdAt": createdAt, "attachments": attachments.flatMap { (value: [Attachment?]) -> [ResultMap?] in value.map { (value: Attachment?) -> ResultMap? in value.flatMap { (value: Attachment) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["_id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "_id")
    }
  }

  public var conversationId: String {
    get {
      return resultMap["conversationId"]! as! String
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
    public static let possibleTypes = ["User"]

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
    public static let possibleTypes = ["Attachment"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("url", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("type", type: .nonNull(.scalar(String.self))),
      GraphQLField("size", type: .scalar(Double.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(url: String, name: String, type: String, size: Double? = nil) {
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

    public var name: String {
      get {
        return resultMap["name"]! as! String
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
  /// fragment AttachmentModel on Attachment {
  ///   __typename
  ///   url
  ///   name
  ///   type
  ///   size
  /// }
  public static let fragmentDefinition =
    "fragment AttachmentModel on Attachment { __typename url name type size }"

  public static let possibleTypes = ["Attachment"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("type", type: .nonNull(.scalar(String.self))),
    GraphQLField("size", type: .scalar(Double.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(url: String, name: String, type: String, size: Double? = nil) {
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

  public var name: String {
    get {
      return resultMap["name"]! as! String
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

public struct UserModel: GraphQLFragment {
  /// fragment UserModel on User {
  ///   __typename
  ///   details {
  ///     __typename
  ///     fullName
  ///     avatar
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment UserModel on User { __typename details { __typename fullName avatar } }"

  public static let possibleTypes = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("details", type: .object(Detail.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(details: Detail? = nil) {
    self.init(unsafeResultMap: ["__typename": "User", "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
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
    public static let possibleTypes = ["UserDetails"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("fullName", type: .scalar(String.self)),
      GraphQLField("avatar", type: .scalar(String.self)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(fullName: String? = nil, avatar: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "UserDetails", "fullName": fullName, "avatar": avatar])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
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

    public var avatar: String? {
      get {
        return resultMap["avatar"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "avatar")
      }
    }
  }
}

public struct ConversationModel: GraphQLFragment {
  /// fragment ConversationModel on Conversation {
  ///   __typename
  ///   _id
  ///   content
  ///   createdAt
  ///   participatedUsers {
  ///     __typename
  ///     ...UserModel
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment ConversationModel on Conversation { __typename _id content createdAt participatedUsers { __typename ...UserModel } }"

  public static let possibleTypes = ["Conversation"]

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

  public init(id: String, content: String? = nil, createdAt: Scalar_Date? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Conversation", "_id": id, "content": content, "createdAt": createdAt, "participatedUsers": participatedUsers.flatMap { (value: [ParticipatedUser?]) -> [ResultMap?] in value.map { (value: ParticipatedUser?) -> ResultMap? in value.flatMap { (value: ParticipatedUser) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
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
    public static let possibleTypes = ["User"]

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
  /// fragment FormConnectModel on FormConnectResponse {
  ///   __typename
  ///   form {
  ///     __typename
  ///     ...FormModel
  ///   }
  ///   integration {
  ///     __typename
  ///     ...IntegrationModel
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment FormConnectModel on FormConnectResponse { __typename form { __typename ...FormModel } integration { __typename ...IntegrationModel } }"

  public static let possibleTypes = ["FormConnectResponse"]

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
    public static let possibleTypes = ["Form"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(FormModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String? = nil, title: String? = nil, description: String? = nil, buttonText: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Form", "_id": id, "title": title, "description": description, "buttonText": buttonText])
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
    public static let possibleTypes = ["Integration"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(IntegrationModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String, name: String? = nil, leadData: Scalar_JSON? = nil) {
      self.init(unsafeResultMap: ["__typename": "Integration", "_id": id, "name": name, "leadData": leadData])
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
  /// fragment FormModel on Form {
  ///   __typename
  ///   _id
  ///   title
  ///   description
  ///   buttonText
  /// }
  public static let fragmentDefinition =
    "fragment FormModel on Form { __typename _id title description buttonText }"

  public static let possibleTypes = ["Form"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("buttonText", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String? = nil, title: String? = nil, description: String? = nil, buttonText: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Form", "_id": id, "title": title, "description": description, "buttonText": buttonText])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String? {
    get {
      return resultMap["_id"] as? String
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
  /// fragment IntegrationModel on Integration {
  ///   __typename
  ///   _id
  ///   name
  ///   leadData
  /// }
  public static let fragmentDefinition =
    "fragment IntegrationModel on Integration { __typename _id name leadData }"

  public static let possibleTypes = ["Integration"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("leadData", type: .scalar(Scalar_JSON.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, name: String? = nil, leadData: Scalar_JSON? = nil) {
    self.init(unsafeResultMap: ["__typename": "Integration", "_id": id, "name": name, "leadData": leadData])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
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

  public var leadData: Scalar_JSON? {
    get {
      return resultMap["leadData"] as? Scalar_JSON
    }
    set {
      resultMap.updateValue(newValue, forKey: "leadData")
    }
  }
}

public struct KnowledgeBaseTopicModel: GraphQLFragment {
  /// fragment KnowledgeBaseTopicModel on KnowledgeBaseTopic {
  ///   __typename
  ///   title
  ///   description
  ///   categories {
  ///     __typename
  ///     ...KnowledgeBaseCategoryModel
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment KnowledgeBaseTopicModel on KnowledgeBaseTopic { __typename title description categories { __typename ...KnowledgeBaseCategoryModel } }"

  public static let possibleTypes = ["KnowledgeBaseTopic"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("categories", type: .list(.object(Category.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(title: String? = nil, description: String? = nil, categories: [Category?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseTopic", "title": title, "description": description, "categories": categories.flatMap { (value: [Category?]) -> [ResultMap?] in value.map { (value: Category?) -> ResultMap? in value.flatMap { (value: Category) -> ResultMap in value.resultMap } } }])
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

  public var categories: [Category?]? {
    get {
      return (resultMap["categories"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Category?] in value.map { (value: ResultMap?) -> Category? in value.flatMap { (value: ResultMap) -> Category in Category(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Category?]) -> [ResultMap?] in value.map { (value: Category?) -> ResultMap? in value.flatMap { (value: Category) -> ResultMap in value.resultMap } } }, forKey: "categories")
    }
  }

  public struct Category: GraphQLSelectionSet {
    public static let possibleTypes = ["KnowledgeBaseCategory"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(KnowledgeBaseCategoryModel.self),
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

      public var knowledgeBaseCategoryModel: KnowledgeBaseCategoryModel {
        get {
          return KnowledgeBaseCategoryModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct KnowledgeBaseCategoryModel: GraphQLFragment {
  /// fragment KnowledgeBaseCategoryModel on KnowledgeBaseCategory {
  ///   __typename
  ///   _id
  ///   title
  ///   description
  ///   numOfArticles
  ///   icon
  ///   articles {
  ///     __typename
  ///     ...KBArticleModel
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment KnowledgeBaseCategoryModel on KnowledgeBaseCategory { __typename _id title description numOfArticles icon articles { __typename ...KBArticleModel } }"

  public static let possibleTypes = ["KnowledgeBaseCategory"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("numOfArticles", type: .scalar(Int.self)),
    GraphQLField("icon", type: .scalar(String.self)),
    GraphQLField("articles", type: .list(.object(Article.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String? = nil, title: String? = nil, description: String? = nil, numOfArticles: Int? = nil, icon: String? = nil, articles: [Article?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseCategory", "_id": id, "title": title, "description": description, "numOfArticles": numOfArticles, "icon": icon, "articles": articles.flatMap { (value: [Article?]) -> [ResultMap?] in value.map { (value: Article?) -> ResultMap? in value.flatMap { (value: Article) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String? {
    get {
      return resultMap["_id"] as? String
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

  public var numOfArticles: Int? {
    get {
      return resultMap["numOfArticles"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "numOfArticles")
    }
  }

  public var icon: String? {
    get {
      return resultMap["icon"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "icon")
    }
  }

  public var articles: [Article?]? {
    get {
      return (resultMap["articles"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Article?] in value.map { (value: ResultMap?) -> Article? in value.flatMap { (value: ResultMap) -> Article in Article(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Article?]) -> [ResultMap?] in value.map { (value: Article?) -> ResultMap? in value.flatMap { (value: Article) -> ResultMap in value.resultMap } } }, forKey: "articles")
    }
  }

  public struct Article: GraphQLSelectionSet {
    public static let possibleTypes = ["KnowledgeBaseArticle"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(KbArticleModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String? = nil, title: String? = nil, summary: String? = nil, content: String? = nil, createdDate: Scalar_Date? = nil) {
      self.init(unsafeResultMap: ["__typename": "KnowledgeBaseArticle", "_id": id, "title": title, "summary": summary, "content": content, "createdDate": createdDate])
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

      public var kbArticleModel: KbArticleModel {
        get {
          return KbArticleModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ConnectResponseModel: GraphQLFragment {
  /// fragment ConnectResponseModel on MessengerConnectResponse {
  ///   __typename
  ///   integrationId
  ///   uiOptions
  ///   languageCode
  ///   messengerData
  ///   customerId
  ///   brand {
  ///     __typename
  ///     ...BrandModel
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment ConnectResponseModel on MessengerConnectResponse { __typename integrationId uiOptions languageCode messengerData customerId brand { __typename ...BrandModel } }"

  public static let possibleTypes = ["MessengerConnectResponse"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("integrationId", type: .scalar(String.self)),
    GraphQLField("uiOptions", type: .scalar(Scalar_JSON.self)),
    GraphQLField("languageCode", type: .scalar(String.self)),
    GraphQLField("messengerData", type: .scalar(Scalar_JSON.self)),
    GraphQLField("customerId", type: .scalar(String.self)),
    GraphQLField("brand", type: .object(Brand.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(integrationId: String? = nil, uiOptions: Scalar_JSON? = nil, languageCode: String? = nil, messengerData: Scalar_JSON? = nil, customerId: String? = nil, brand: Brand? = nil) {
    self.init(unsafeResultMap: ["__typename": "MessengerConnectResponse", "integrationId": integrationId, "uiOptions": uiOptions, "languageCode": languageCode, "messengerData": messengerData, "customerId": customerId, "brand": brand.flatMap { (value: Brand) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var integrationId: String? {
    get {
      return resultMap["integrationId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "integrationId")
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

  public var languageCode: String? {
    get {
      return resultMap["languageCode"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "languageCode")
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

  public var customerId: String? {
    get {
      return resultMap["customerId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "customerId")
    }
  }

  public var brand: Brand? {
    get {
      return (resultMap["brand"] as? ResultMap).flatMap { Brand(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "brand")
    }
  }

  public struct Brand: GraphQLSelectionSet {
    public static let possibleTypes = ["Brand"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(BrandModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String, code: String, description: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Brand", "name": name, "code": code, "description": description])
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

      public var brandModel: BrandModel {
        get {
          return BrandModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct BrandModel: GraphQLFragment {
  /// fragment BrandModel on Brand {
  ///   __typename
  ///   name
  ///   code
  ///   description
  /// }
  public static let fragmentDefinition =
    "fragment BrandModel on Brand { __typename name code description }"

  public static let possibleTypes = ["Brand"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("code", type: .nonNull(.scalar(String.self))),
    GraphQLField("description", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(name: String, code: String, description: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Brand", "name": name, "code": code, "description": description])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
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

  public var code: String {
    get {
      return resultMap["code"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
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

public struct KbModel: GraphQLFragment {
  /// fragment KBModel on KnowledgeBaseCategory {
  ///   __typename
  ///   _id
  ///   title
  ///   description
  ///   numOfArticles
  ///   icon
  ///   articles {
  ///     __typename
  ///     ...KBArticleModel
  ///   }
  /// }
  public static let fragmentDefinition =
    "fragment KBModel on KnowledgeBaseCategory { __typename _id title description numOfArticles icon articles { __typename ...KBArticleModel } }"

  public static let possibleTypes = ["KnowledgeBaseCategory"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("numOfArticles", type: .scalar(Int.self)),
    GraphQLField("icon", type: .scalar(String.self)),
    GraphQLField("articles", type: .list(.object(Article.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String? = nil, title: String? = nil, description: String? = nil, numOfArticles: Int? = nil, icon: String? = nil, articles: [Article?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseCategory", "_id": id, "title": title, "description": description, "numOfArticles": numOfArticles, "icon": icon, "articles": articles.flatMap { (value: [Article?]) -> [ResultMap?] in value.map { (value: Article?) -> ResultMap? in value.flatMap { (value: Article) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String? {
    get {
      return resultMap["_id"] as? String
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

  public var numOfArticles: Int? {
    get {
      return resultMap["numOfArticles"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "numOfArticles")
    }
  }

  public var icon: String? {
    get {
      return resultMap["icon"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "icon")
    }
  }

  public var articles: [Article?]? {
    get {
      return (resultMap["articles"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Article?] in value.map { (value: ResultMap?) -> Article? in value.flatMap { (value: ResultMap) -> Article in Article(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Article?]) -> [ResultMap?] in value.map { (value: Article?) -> ResultMap? in value.flatMap { (value: Article) -> ResultMap in value.resultMap } } }, forKey: "articles")
    }
  }

  public struct Article: GraphQLSelectionSet {
    public static let possibleTypes = ["KnowledgeBaseArticle"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(KbArticleModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String? = nil, title: String? = nil, summary: String? = nil, content: String? = nil, createdDate: Scalar_Date? = nil) {
      self.init(unsafeResultMap: ["__typename": "KnowledgeBaseArticle", "_id": id, "title": title, "summary": summary, "content": content, "createdDate": createdDate])
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

      public var kbArticleModel: KbArticleModel {
        get {
          return KbArticleModel(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct KbArticleModel: GraphQLFragment {
  /// fragment KBArticleModel on KnowledgeBaseArticle {
  ///   __typename
  ///   _id
  ///   title
  ///   summary
  ///   content
  ///   createdDate
  /// }
  public static let fragmentDefinition =
    "fragment KBArticleModel on KnowledgeBaseArticle { __typename _id title summary content createdDate }"

  public static let possibleTypes = ["KnowledgeBaseArticle"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("summary", type: .scalar(String.self)),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("createdDate", type: .scalar(Scalar_Date.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String? = nil, title: String? = nil, summary: String? = nil, content: String? = nil, createdDate: Scalar_Date? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseArticle", "_id": id, "title": title, "summary": summary, "content": content, "createdDate": createdDate])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String? {
    get {
      return resultMap["_id"] as? String
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

  public var summary: String? {
    get {
      return resultMap["summary"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "summary")
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

  public var createdDate: Scalar_Date? {
    get {
      return resultMap["createdDate"] as? Scalar_Date
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdDate")
    }
  }
}
