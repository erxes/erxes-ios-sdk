// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MessengerSupportersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query MessengerSupporters($integrationId: String!) {
      widgetsMessengerSupporters(integrationId: $integrationId) {
        __typename
        ...UserModel
      }
    }
    """

  public let operationName: String = "MessengerSupporters"

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
      GraphQLField("widgetsMessengerSupporters", arguments: ["integrationId": GraphQLVariable("integrationId")], type: .list(.object(WidgetsMessengerSupporter.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(widgetsMessengerSupporters: [WidgetsMessengerSupporter?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "widgetsMessengerSupporters": widgetsMessengerSupporters.flatMap { (value: [WidgetsMessengerSupporter?]) -> [ResultMap?] in value.map { (value: WidgetsMessengerSupporter?) -> ResultMap? in value.flatMap { (value: WidgetsMessengerSupporter) -> ResultMap in value.resultMap } } }])
    }

    public var widgetsMessengerSupporters: [WidgetsMessengerSupporter?]? {
      get {
        return (resultMap["widgetsMessengerSupporters"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [WidgetsMessengerSupporter?] in value.map { (value: ResultMap?) -> WidgetsMessengerSupporter? in value.flatMap { (value: ResultMap) -> WidgetsMessengerSupporter in WidgetsMessengerSupporter(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [WidgetsMessengerSupporter?]) -> [ResultMap?] in value.map { (value: WidgetsMessengerSupporter?) -> ResultMap? in value.flatMap { (value: WidgetsMessengerSupporter) -> ResultMap in value.resultMap } } }, forKey: "widgetsMessengerSupporters")
      }
    }

    public struct WidgetsMessengerSupporter: GraphQLSelectionSet {
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

public struct UserModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserModel on User {
      __typename
      details {
        __typename
        fullName
        avatar
      }
    }
    """

  public static let possibleTypes: [String] = ["User"]

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
    public static let possibleTypes: [String] = ["UserDetailsType"]

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
      self.init(unsafeResultMap: ["__typename": "UserDetailsType", "fullName": fullName, "avatar": avatar])
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
