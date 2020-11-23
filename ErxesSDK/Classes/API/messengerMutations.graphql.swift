// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class ConnectMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation connect($brandCode: String!, $email: String, $phone: String, $code: String, $isUser: Boolean, $data: JSON, $companyData: JSON, $cachedCustomerId: String) {
      widgetsMessengerConnect(brandCode: $brandCode, email: $email, phone: $phone, code: $code, isUser: $isUser, data: $data, companyData: $companyData, cachedCustomerId: $cachedCustomerId) {
        __typename
        ...ConnectResponseModel
      }
    }
    """

  public let operationName: String = "connect"

  public var queryDocument: String { return operationDefinition.appending("\n" + ConnectResponseModel.fragmentDefinition).appending("\n" + BrandModel.fragmentDefinition) }

  public var brandCode: String
  public var email: String?
  public var phone: String?
  public var code: String?
  public var isUser: Bool?
  public var data: Scalar_JSON?
  public var companyData: Scalar_JSON?
  public var cachedCustomerId: String?

  public init(brandCode: String, email: String? = nil, phone: String? = nil, code: String? = nil, isUser: Bool? = nil, data: Scalar_JSON? = nil, companyData: Scalar_JSON? = nil, cachedCustomerId: String? = nil) {
    self.brandCode = brandCode
    self.email = email
    self.phone = phone
    self.code = code
    self.isUser = isUser
    self.data = data
    self.companyData = companyData
    self.cachedCustomerId = cachedCustomerId
  }

  public var variables: GraphQLMap? {
    return ["brandCode": brandCode, "email": email, "phone": phone, "code": code, "isUser": isUser, "data": data, "companyData": companyData, "cachedCustomerId": cachedCustomerId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsMessengerConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "email": GraphQLVariable("email"), "phone": GraphQLVariable("phone"), "code": GraphQLVariable("code"), "isUser": GraphQLVariable("isUser"), "data": GraphQLVariable("data"), "companyData": GraphQLVariable("companyData"), "cachedCustomerId": GraphQLVariable("cachedCustomerId")], type: .object(WidgetsMessengerConnect.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsMessengerConnect: WidgetsMessengerConnect? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsMessengerConnect": widgetsMessengerConnect.flatMap { (value: WidgetsMessengerConnect) -> ResultMap in value.resultMap }])
    }

    public var widgetsMessengerConnect: WidgetsMessengerConnect? {
      get {
        return (resultMap["widgetsMessengerConnect"] as? ResultMap).flatMap { WidgetsMessengerConnect(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsMessengerConnect")
      }
    }

    public struct WidgetsMessengerConnect: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MessengerConnectResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ConnectResponseModel.self),
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

public final class WidgetsSaveBrowserInfoMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsSaveBrowserInfo($customerId: String!, $browserInfo: JSON!) {
      widgetsSaveBrowserInfo(customerId: $customerId, browserInfo: $browserInfo) {
        __typename
        ...MessageModel
      }
    }
    """

  public let operationName: String = "widgetsSaveBrowserInfo"

  public var queryDocument: String { return operationDefinition.appending("\n" + MessageModel.fragmentDefinition).appending("\n" + UserModel.fragmentDefinition) }

  public var customerId: String
  public var browserInfo: Scalar_JSON

  public init(customerId: String, browserInfo: Scalar_JSON) {
    self.customerId = customerId
    self.browserInfo = browserInfo
  }

  public var variables: GraphQLMap? {
    return ["customerId": customerId, "browserInfo": browserInfo]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsSaveBrowserInfo", arguments: ["customerId": GraphQLVariable("customerId"), "browserInfo": GraphQLVariable("browserInfo")], type: .object(WidgetsSaveBrowserInfo.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsSaveBrowserInfo: WidgetsSaveBrowserInfo? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsSaveBrowserInfo": widgetsSaveBrowserInfo.flatMap { (value: WidgetsSaveBrowserInfo) -> ResultMap in value.resultMap }])
    }

    public var widgetsSaveBrowserInfo: WidgetsSaveBrowserInfo? {
      get {
        return (resultMap["widgetsSaveBrowserInfo"] as? ResultMap).flatMap { WidgetsSaveBrowserInfo(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "widgetsSaveBrowserInfo")
      }
    }

    public struct WidgetsSaveBrowserInfo: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ConversationMessage"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MessageModel.self),
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

public final class WidgetsInsertMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsInsertMessage($integrationId: String!, $customerId: String!, $message: String, $contentType: String, $conversationId: String, $attachments: [AttachmentInput]) {
      widgetsInsertMessage(integrationId: $integrationId, customerId: $customerId, contentType: $contentType, message: $message, conversationId: $conversationId, attachments: $attachments) {
        __typename
        ...MessageModel
      }
    }
    """

  public let operationName: String = "widgetsInsertMessage"

  public var queryDocument: String { return operationDefinition.appending("\n" + MessageModel.fragmentDefinition).appending("\n" + UserModel.fragmentDefinition) }

  public var integrationId: String
  public var customerId: String
  public var message: String?
  public var contentType: String?
  public var conversationId: String?
  public var attachments: [AttachmentInput?]?

  public init(integrationId: String, customerId: String, message: String? = nil, contentType: String? = nil, conversationId: String? = nil, attachments: [AttachmentInput?]? = nil) {
    self.integrationId = integrationId
    self.customerId = customerId
    self.message = message
    self.contentType = contentType
    self.conversationId = conversationId
    self.attachments = attachments
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId, "customerId": customerId, "message": message, "contentType": contentType, "conversationId": conversationId, "attachments": attachments]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsInsertMessage", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId"), "contentType": GraphQLVariable("contentType"), "message": GraphQLVariable("message"), "conversationId": GraphQLVariable("conversationId"), "attachments": GraphQLVariable("attachments")], type: .object(WidgetsInsertMessage.selections)),
      ]
    }

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

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MessageModel.self),
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

public final class WidgetsReadConversationMessagesMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsReadConversationMessages($conversationId: String!) {
      widgetsReadConversationMessages(conversationId: $conversationId)
    }
    """

  public let operationName: String = "widgetsReadConversationMessages"

  public var conversationId: String

  public init(conversationId: String) {
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsReadConversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(Scalar_JSON.self)),
      ]
    }

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

public final class WidgetsSaveCustomerGetNotifiedMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation widgetsSaveCustomerGetNotified($customerId: String!, $type: String!, $value: String!) {
      widgetsSaveCustomerGetNotified(customerId: $customerId, type: $type, value: $value)
    }
    """

  public let operationName: String = "widgetsSaveCustomerGetNotified"

  public var customerId: String
  public var type: String
  public var value: String

  public init(customerId: String, type: String, value: String) {
    self.customerId = customerId
    self.type = type
    self.value = value
  }

  public var variables: GraphQLMap? {
    return ["customerId": customerId, "type": type, "value": value]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("widgetsSaveCustomerGetNotified", arguments: ["customerId": GraphQLVariable("customerId"), "type": GraphQLVariable("type"), "value": GraphQLVariable("value")], type: .scalar(Scalar_JSON.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsSaveCustomerGetNotified: Scalar_JSON? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "widgetsSaveCustomerGetNotified": widgetsSaveCustomerGetNotified])
    }

    public var widgetsSaveCustomerGetNotified: Scalar_JSON? {
      get {
        return resultMap["widgetsSaveCustomerGetNotified"] as? Scalar_JSON
      }
      set {
        resultMap.updateValue(newValue, forKey: "widgetsSaveCustomerGetNotified")
      }
    }
  }
}

public struct ConnectResponseModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConnectResponseModel on MessengerConnectResponse {
      __typename
      integrationId
      messengerData
      languageCode
      uiOptions
      customerId
      brand {
        __typename
        ...BrandModel
      }
    }
    """

  public static let possibleTypes: [String] = ["MessengerConnectResponse"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("integrationId", type: .scalar(String.self)),
      GraphQLField("messengerData", type: .scalar(Scalar_JSON.self)),
      GraphQLField("languageCode", type: .scalar(String.self)),
      GraphQLField("uiOptions", type: .scalar(Scalar_JSON.self)),
      GraphQLField("customerId", type: .scalar(String.self)),
      GraphQLField("brand", type: .object(Brand.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(integrationId: String? = nil, messengerData: Scalar_JSON? = nil, languageCode: String? = nil, uiOptions: Scalar_JSON? = nil, customerId: String? = nil, brand: Brand? = nil) {
    self.init(unsafeResultMap: ["__typename": "MessengerConnectResponse", "integrationId": integrationId, "messengerData": messengerData, "languageCode": languageCode, "uiOptions": uiOptions, "customerId": customerId, "brand": brand.flatMap { (value: Brand) -> ResultMap in value.resultMap }])
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

  public var messengerData: Scalar_JSON? {
    get {
      return resultMap["messengerData"] as? Scalar_JSON
    }
    set {
      resultMap.updateValue(newValue, forKey: "messengerData")
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
    public static let possibleTypes: [String] = ["Brand"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(BrandModel.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String, name: String? = nil, description: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Brand", "_id": _id, "name": name, "description": description])
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
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment BrandModel on Brand {
      __typename
      _id
      name
      description
    }
    """

  public static let possibleTypes: [String] = ["Brand"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("_id", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("description", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, name: String? = nil, description: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Brand", "_id": _id, "name": name, "description": description])
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

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
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
      customerId
      conversationId
      user {
        __typename
        ...UserModel
      }
      content
      createdAt
      internal
      fromBot
      contentType
      videoCallData {
        __typename
        url
        status
      }
      engageData {
        __typename
        content
        kind
        sentAs
        messageId
        brandId
      }
      messengerAppData
      attachments {
        __typename
        url
        name
        size
        type
      }
    }
    """

  public static let possibleTypes: [String] = ["ConversationMessage"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("_id", type: .nonNull(.scalar(String.self))),
      GraphQLField("customerId", type: .scalar(String.self)),
      GraphQLField("conversationId", type: .scalar(String.self)),
      GraphQLField("user", type: .object(User.selections)),
      GraphQLField("content", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .scalar(Scalar_Date.self)),
      GraphQLField("internal", type: .scalar(Bool.self)),
      GraphQLField("fromBot", type: .scalar(Bool.self)),
      GraphQLField("contentType", type: .scalar(String.self)),
      GraphQLField("videoCallData", type: .object(VideoCallDatum.selections)),
      GraphQLField("engageData", type: .object(EngageDatum.selections)),
      GraphQLField("messengerAppData", type: .scalar(Scalar_JSON.self)),
      GraphQLField("attachments", type: .list(.object(Attachment.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String, customerId: String? = nil, conversationId: String? = nil, user: User? = nil, content: String? = nil, createdAt: Scalar_Date? = nil, `internal`: Bool? = nil, fromBot: Bool? = nil, contentType: String? = nil, videoCallData: VideoCallDatum? = nil, engageData: EngageDatum? = nil, messengerAppData: Scalar_JSON? = nil, attachments: [Attachment?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": _id, "customerId": customerId, "conversationId": conversationId, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "content": content, "createdAt": createdAt, "internal": `internal`, "fromBot": fromBot, "contentType": contentType, "videoCallData": videoCallData.flatMap { (value: VideoCallDatum) -> ResultMap in value.resultMap }, "engageData": engageData.flatMap { (value: EngageDatum) -> ResultMap in value.resultMap }, "messengerAppData": messengerAppData, "attachments": attachments.flatMap { (value: [Attachment?]) -> [ResultMap?] in value.map { (value: Attachment?) -> ResultMap? in value.flatMap { (value: Attachment) -> ResultMap in value.resultMap } } }])
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

  public var customerId: String? {
    get {
      return resultMap["customerId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "customerId")
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

  public var `internal`: Bool? {
    get {
      return resultMap["internal"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "internal")
    }
  }

  public var fromBot: Bool? {
    get {
      return resultMap["fromBot"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "fromBot")
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

  public var videoCallData: VideoCallDatum? {
    get {
      return (resultMap["videoCallData"] as? ResultMap).flatMap { VideoCallDatum(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "videoCallData")
    }
  }

  public var engageData: EngageDatum? {
    get {
      return (resultMap["engageData"] as? ResultMap).flatMap { EngageDatum(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "engageData")
    }
  }

  public var messengerAppData: Scalar_JSON? {
    get {
      return resultMap["messengerAppData"] as? Scalar_JSON
    }
    set {
      resultMap.updateValue(newValue, forKey: "messengerAppData")
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

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(UserModel.self),
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

  public struct VideoCallDatum: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["VideoCallData"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .scalar(String.self)),
        GraphQLField("status", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(url: String? = nil, status: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "VideoCallData", "url": url, "status": status])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var url: String? {
      get {
        return resultMap["url"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "url")
      }
    }

    public var status: String? {
      get {
        return resultMap["status"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "status")
      }
    }
  }

  public struct EngageDatum: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["EngageData"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("kind", type: .scalar(String.self)),
        GraphQLField("sentAs", type: .scalar(String.self)),
        GraphQLField("messageId", type: .scalar(String.self)),
        GraphQLField("brandId", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(content: String? = nil, kind: String? = nil, sentAs: String? = nil, messageId: String? = nil, brandId: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "EngageData", "content": content, "kind": kind, "sentAs": sentAs, "messageId": messageId, "brandId": brandId])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
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

    public var kind: String? {
      get {
        return resultMap["kind"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "kind")
      }
    }

    public var sentAs: String? {
      get {
        return resultMap["sentAs"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "sentAs")
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

    public var brandId: String? {
      get {
        return resultMap["brandId"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "brandId")
      }
    }
  }

  public struct Attachment: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Attachment"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("size", type: .scalar(Double.self)),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(url: String, name: String? = nil, size: Double? = nil, type: String) {
      self.init(unsafeResultMap: ["__typename": "Attachment", "url": url, "name": name, "size": size, "type": type])
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

    public var size: Double? {
      get {
        return resultMap["size"] as? Double
      }
      set {
        resultMap.updateValue(newValue, forKey: "size")
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
  }
}
