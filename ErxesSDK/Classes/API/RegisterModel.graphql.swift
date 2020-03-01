// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MessengerConnectMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation MessengerConnect($brandCode: String!, $email: String, $phone: String, $isUser: Boolean, $data: JSON, $companyData: JSON, $cachedCustomerId: String, $deviceToken: String) {
      widgetsMessengerConnect(brandCode: $brandCode, email: $email, phone: $phone, isUser: $isUser, data: $data, companyData: $companyData, deviceToken: $deviceToken, cachedCustomerId: $cachedCustomerId) {
        __typename
        ...ConnectResponseModel
      }
    }
    """

  public let operationName: String = "MessengerConnect"

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
    public static let possibleTypes: [String] = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("widgetsMessengerConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "email": GraphQLVariable("email"), "phone": GraphQLVariable("phone"), "isUser": GraphQLVariable("isUser"), "data": GraphQLVariable("data"), "companyData": GraphQLVariable("companyData"), "deviceToken": GraphQLVariable("deviceToken"), "cachedCustomerId": GraphQLVariable("cachedCustomerId")], type: .object(WidgetsMessengerConnect.selections)),
    ]

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

public struct ConnectResponseModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConnectResponseModel on MessengerConnectResponse {
      __typename
      integrationId
      uiOptions
      languageCode
      messengerData
      customerId
      brand {
        __typename
        ...BrandModel
      }
    }
    """

  public static let possibleTypes: [String] = ["MessengerConnectResponse"]

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
    public static let possibleTypes: [String] = ["Brand"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(BrandModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String? = nil, code: String? = nil, description: String? = nil) {
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
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment BrandModel on Brand {
      __typename
      name
      code
      description
    }
    """

  public static let possibleTypes: [String] = ["Brand"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("code", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(name: String? = nil, code: String? = nil, description: String? = nil) {
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

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
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

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }
}
