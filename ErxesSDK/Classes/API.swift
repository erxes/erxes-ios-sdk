//  This file was automatically generated and should not be edited.

import Apollo

public final class LastUnreadMessageQuery: GraphQLQuery {
  public static let operationString =
    "query lastUnreadMessage($integrationId: String!, $customerId: String!) {\n  lastUnreadMessage(integrationId: $integrationId, customerId: $customerId) {\n    __typename\n    _id\n    conversationId\n    content\n    user {\n      __typename\n      details {\n        __typename\n        fullName\n        avatar\n      }\n    }\n    engageData {\n      __typename\n      messageId\n      content\n      kind\n      sentAs\n      fromUser {\n        __typename\n        details {\n          __typename\n          fullName\n          avatar\n        }\n      }\n    }\n  }\n}"

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
      GraphQLField("lastUnreadMessage", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId")], type: .object(LastUnreadMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(lastUnreadMessage: LastUnreadMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "lastUnreadMessage": lastUnreadMessage.flatMap { $0.snapshot }])
    }

    public var lastUnreadMessage: LastUnreadMessage? {
      get {
        return (snapshot["lastUnreadMessage"] as? Snapshot).flatMap { LastUnreadMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "lastUnreadMessage")
      }
    }

    public struct LastUnreadMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversationId", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("engageData", type: .object(EngageDatum.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: String, conversationId: String, content: String? = nil, user: User? = nil, engageData: EngageDatum? = nil) {
        self.init(snapshot: ["__typename": "ConversationMessage", "_id": id, "conversationId": conversationId, "content": content, "user": user.flatMap { $0.snapshot }, "engageData": engageData.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return snapshot["_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "_id")
        }
      }

      public var conversationId: String {
        get {
          return snapshot["conversationId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var engageData: EngageDatum? {
        get {
          return (snapshot["engageData"] as? Snapshot).flatMap { EngageDatum(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "engageData")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("details", type: .object(Detail.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(details: Detail? = nil) {
          self.init(snapshot: ["__typename": "User", "details": details.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var details: Detail? {
          get {
            return (snapshot["details"] as? Snapshot).flatMap { Detail(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "details")
          }
        }

        public struct Detail: GraphQLSelectionSet {
          public static let possibleTypes = ["UserDetails"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("fullName", type: .scalar(String.self)),
            GraphQLField("avatar", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(fullName: String? = nil, avatar: String? = nil) {
            self.init(snapshot: ["__typename": "UserDetails", "fullName": fullName, "avatar": avatar])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fullName: String? {
            get {
              return snapshot["fullName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "fullName")
            }
          }

          public var avatar: String? {
            get {
              return snapshot["avatar"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "avatar")
            }
          }
        }
      }

      public struct EngageDatum: GraphQLSelectionSet {
        public static let possibleTypes = ["EngageData"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("messageId", type: .scalar(String.self)),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("kind", type: .scalar(String.self)),
          GraphQLField("sentAs", type: .scalar(String.self)),
          GraphQLField("fromUser", type: .object(FromUser.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(messageId: String? = nil, content: String? = nil, kind: String? = nil, sentAs: String? = nil, fromUser: FromUser? = nil) {
          self.init(snapshot: ["__typename": "EngageData", "messageId": messageId, "content": content, "kind": kind, "sentAs": sentAs, "fromUser": fromUser.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var messageId: String? {
          get {
            return snapshot["messageId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "messageId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var kind: String? {
          get {
            return snapshot["kind"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "kind")
          }
        }

        public var sentAs: String? {
          get {
            return snapshot["sentAs"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sentAs")
          }
        }

        public var fromUser: FromUser? {
          get {
            return (snapshot["fromUser"] as? Snapshot).flatMap { FromUser(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "fromUser")
          }
        }

        public struct FromUser: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("details", type: .object(Detail.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(details: Detail? = nil) {
            self.init(snapshot: ["__typename": "User", "details": details.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var details: Detail? {
            get {
              return (snapshot["details"] as? Snapshot).flatMap { Detail(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "details")
            }
          }

          public struct Detail: GraphQLSelectionSet {
            public static let possibleTypes = ["UserDetails"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("fullName", type: .scalar(String.self)),
              GraphQLField("avatar", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(fullName: String? = nil, avatar: String? = nil) {
              self.init(snapshot: ["__typename": "UserDetails", "fullName": fullName, "avatar": avatar])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fullName: String? {
              get {
                return snapshot["fullName"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "fullName")
              }
            }

            public var avatar: String? {
              get {
                return snapshot["avatar"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "avatar")
              }
            }
          }
        }
      }
    }
  }
}

public final class ReadConversationMessagesMutation: GraphQLMutation {
  public static let operationString =
    "mutation ReadConversationMessages($conversationId: String!) {\n  readConversationMessages(conversationId: $conversationId)\n}"

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
      GraphQLField("readConversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(readConversationMessages: String? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "readConversationMessages": readConversationMessages])
    }

    public var readConversationMessages: String? {
      get {
        return snapshot["readConversationMessages"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "readConversationMessages")
      }
    }
  }
}

public final class ConversationsQuery: GraphQLQuery {
  public static let operationString =
    "query Conversations($integrationId: String!, $customerId: String!) {\n  conversations(integrationId: $integrationId, customerId: $customerId) {\n    __typename\n    ...ConversationDetail\n  }\n}"

  public static var requestString: String { return operationString.appending(ConversationDetail.fragmentString) }

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

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(conversations: [Conversation?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "conversations": conversations.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var conversations: [Conversation?]? {
      get {
        return (snapshot["conversations"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Conversation(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "conversations")
      }
    }

    public struct Conversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("messages", type: .list(.object(Message.selections))),
        GraphQLField("status", type: .nonNull(.scalar(String.self))),
        GraphQLField("readUserIds", type: .list(.scalar(String.self))),
        GraphQLField("participatedUsers", type: .list(.object(ParticipatedUser.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: String, content: String? = nil, createdAt: String? = nil, messages: [Message?]? = nil, status: String, readUserIds: [String?]? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
        self.init(snapshot: ["__typename": "Conversation", "_id": id, "content": content, "createdAt": createdAt, "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "status": status, "readUserIds": readUserIds, "participatedUsers": participatedUsers.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return snapshot["_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "_id")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var messages: [Message?]? {
        get {
          return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
        }
      }

      public var status: String {
        get {
          return snapshot["status"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "status")
        }
      }

      public var readUserIds: [String?]? {
        get {
          return snapshot["readUserIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "readUserIds")
        }
      }

      public var participatedUsers: [ParticipatedUser?]? {
        get {
          return (snapshot["participatedUsers"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { ParticipatedUser(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "participatedUsers")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var conversationDetail: ConversationDetail {
          get {
            return ConversationDetail(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ConversationMessage"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("customerId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(customerId: String? = nil, createdAt: String? = nil) {
          self.init(snapshot: ["__typename": "ConversationMessage", "customerId": customerId, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var customerId: String? {
          get {
            return snapshot["customerId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "customerId")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }
      }

      public struct ParticipatedUser: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("details", type: .object(Detail.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: String, details: Detail? = nil) {
          self.init(snapshot: ["__typename": "User", "_id": id, "details": details.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: String {
          get {
            return snapshot["_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "_id")
          }
        }

        public var details: Detail? {
          get {
            return (snapshot["details"] as? Snapshot).flatMap { Detail(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "details")
          }
        }

        public struct Detail: GraphQLSelectionSet {
          public static let possibleTypes = ["UserDetails"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("fullName", type: .scalar(String.self)),
            GraphQLField("avatar", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(fullName: String? = nil, avatar: String? = nil) {
            self.init(snapshot: ["__typename": "UserDetails", "fullName": fullName, "avatar": avatar])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fullName: String? {
            get {
              return snapshot["fullName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "fullName")
            }
          }

          public var avatar: String? {
            get {
              return snapshot["avatar"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "avatar")
            }
          }
        }
      }
    }
  }
}

public final class ConnectMutation: GraphQLMutation {
  public static let operationString =
    "mutation Connect($brandCode: String!, $email: String!, $isUser: Boolean!) {\n  messengerConnect(brandCode: $brandCode, email: $email, isUser: $isUser) {\n    __typename\n    integrationId\n    messengerData\n    uiOptions\n    customerId\n  }\n}"

  public var brandCode: String
  public var email: String
  public var isUser: Bool

  public init(brandCode: String, email: String, isUser: Bool) {
    self.brandCode = brandCode
    self.email = email
    self.isUser = isUser
  }

  public var variables: GraphQLMap? {
    return ["brandCode": brandCode, "email": email, "isUser": isUser]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messengerConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "email": GraphQLVariable("email"), "isUser": GraphQLVariable("isUser")], type: .object(MessengerConnect.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(messengerConnect: MessengerConnect? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "messengerConnect": messengerConnect.flatMap { $0.snapshot }])
    }

    public var messengerConnect: MessengerConnect? {
      get {
        return (snapshot["messengerConnect"] as? Snapshot).flatMap { MessengerConnect(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "messengerConnect")
      }
    }

    public struct MessengerConnect: GraphQLSelectionSet {
      public static let possibleTypes = ["MessengerConnectResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("integrationId", type: .scalar(String.self)),
        GraphQLField("messengerData", type: .scalar(String.self)),
        GraphQLField("uiOptions", type: .scalar(String.self)),
        GraphQLField("customerId", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(integrationId: String? = nil, messengerData: String? = nil, uiOptions: String? = nil, customerId: String? = nil) {
        self.init(snapshot: ["__typename": "MessengerConnectResponse", "integrationId": integrationId, "messengerData": messengerData, "uiOptions": uiOptions, "customerId": customerId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var integrationId: String? {
        get {
          return snapshot["integrationId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "integrationId")
        }
      }

      public var messengerData: String? {
        get {
          return snapshot["messengerData"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "messengerData")
        }
      }

      public var uiOptions: String? {
        get {
          return snapshot["uiOptions"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "uiOptions")
        }
      }

      public var customerId: String? {
        get {
          return snapshot["customerId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "customerId")
        }
      }
    }
  }
}

public final class TotalUnreadCountQuery: GraphQLQuery {
  public static let operationString =
    "query totalUnreadCount($integrationId: String!, $customerId: String!) {\n  totalUnreadCount(integrationId: $integrationId, customerId: $customerId)\n}"

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
      GraphQLField("totalUnreadCount", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId")], type: .scalar(Int.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(totalUnreadCount: Int? = nil) {
      self.init(snapshot: ["__typename": "Query", "totalUnreadCount": totalUnreadCount])
    }

    public var totalUnreadCount: Int? {
      get {
        return snapshot["totalUnreadCount"] as? Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "totalUnreadCount")
      }
    }
  }
}

public final class UnreadCountQuery: GraphQLQuery {
  public static let operationString =
    "query UnreadCount($conversationId: String!) {\n  unreadCount(conversationId: $conversationId)\n}"

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
      GraphQLField("unreadCount", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(Int.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(unreadCount: Int? = nil) {
      self.init(snapshot: ["__typename": "Query", "unreadCount": unreadCount])
    }

    public var unreadCount: Int? {
      get {
        return snapshot["unreadCount"] as? Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "unreadCount")
      }
    }
  }
}

public final class InsertMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation insertMessage($integrationId: String!, $customerId: String!, $message: String, $conversationId: String) {\n  insertMessage(integrationId: $integrationId, customerId: $customerId, message: $message, conversationId: $conversationId) {\n    __typename\n    _id\n    conversationId\n  }\n}"

  public var integrationId: String
  public var customerId: String
  public var message: String?
  public var conversationId: String?

  public init(integrationId: String, customerId: String, message: String? = nil, conversationId: String? = nil) {
    self.integrationId = integrationId
    self.customerId = customerId
    self.message = message
    self.conversationId = conversationId
  }

  public var variables: GraphQLMap? {
    return ["integrationId": integrationId, "customerId": customerId, "message": message, "conversationId": conversationId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("insertMessage", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId"), "message": GraphQLVariable("message"), "conversationId": GraphQLVariable("conversationId")], type: .object(InsertMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(insertMessage: InsertMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "insertMessage": insertMessage.flatMap { $0.snapshot }])
    }

    public var insertMessage: InsertMessage? {
      get {
        return (snapshot["insertMessage"] as? Snapshot).flatMap { InsertMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "insertMessage")
      }
    }

    public struct InsertMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("conversationId", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: String, conversationId: String) {
        self.init(snapshot: ["__typename": "ConversationMessage", "_id": id, "conversationId": conversationId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return snapshot["_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "_id")
        }
      }

      public var conversationId: String {
        get {
          return snapshot["conversationId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationId")
        }
      }
    }
  }
}

public final class MessagesQuery: GraphQLQuery {
  public static let operationString =
    "query Messages($conversationId: String!) {\n  messages(conversationId: $conversationId) {\n    __typename\n    ...MessageDetail\n  }\n}"

  public static var requestString: String { return operationString.appending(MessageDetail.fragmentString) }

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

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(messages: [Message?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var messages: [Message?]? {
      get {
        return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
      }
    }

    public struct Message: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .object(User.selections)),
        GraphQLField("customerId", type: .scalar(String.self)),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: String, user: User? = nil, customerId: String? = nil, content: String? = nil, createdAt: String? = nil) {
        self.init(snapshot: ["__typename": "ConversationMessage", "_id": id, "user": user.flatMap { $0.snapshot }, "customerId": customerId, "content": content, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return snapshot["_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "_id")
        }
      }

      public var user: User? {
        get {
          return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public var customerId: String? {
        get {
          return snapshot["customerId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "customerId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var messageDetail: MessageDetail {
          get {
            return MessageDetail(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("details", type: .object(Detail.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(details: Detail? = nil) {
          self.init(snapshot: ["__typename": "User", "details": details.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var details: Detail? {
          get {
            return (snapshot["details"] as? Snapshot).flatMap { Detail(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "details")
          }
        }

        public struct Detail: GraphQLSelectionSet {
          public static let possibleTypes = ["UserDetails"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("avatar", type: .scalar(String.self)),
            GraphQLField("fullName", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(avatar: String? = nil, fullName: String? = nil) {
            self.init(snapshot: ["__typename": "UserDetails", "avatar": avatar, "fullName": fullName])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var avatar: String? {
            get {
              return snapshot["avatar"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "avatar")
            }
          }

          public var fullName: String? {
            get {
              return snapshot["fullName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "fullName")
            }
          }
        }
      }
    }
  }
}

public final class ReadMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation ReadMessage($conversationId: String!) {\n  readConversationMessages(conversationId: $conversationId)\n}"

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
      GraphQLField("readConversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(readConversationMessages: String? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "readConversationMessages": readConversationMessages])
    }

    public var readConversationMessages: String? {
      get {
        return snapshot["readConversationMessages"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "readConversationMessages")
      }
    }
  }
}

public struct MessageDetail: GraphQLFragment {
  public static let fragmentString =
    "fragment MessageDetail on ConversationMessage {\n  __typename\n  _id\n  user {\n    __typename\n    details {\n      __typename\n      avatar\n      fullName\n    }\n  }\n  customerId\n  content\n  createdAt\n}"

  public static let possibleTypes = ["ConversationMessage"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("user", type: .object(User.selections)),
    GraphQLField("customerId", type: .scalar(String.self)),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("createdAt", type: .scalar(String.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: String, user: User? = nil, customerId: String? = nil, content: String? = nil, createdAt: String? = nil) {
    self.init(snapshot: ["__typename": "ConversationMessage", "_id": id, "user": user.flatMap { $0.snapshot }, "customerId": customerId, "content": content, "createdAt": createdAt])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return snapshot["_id"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "_id")
    }
  }

  public var user: User? {
    get {
      return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue?.snapshot, forKey: "user")
    }
  }

  public var customerId: String? {
    get {
      return snapshot["customerId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "customerId")
    }
  }

  public var content: String? {
    get {
      return snapshot["content"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: String? {
    get {
      return snapshot["createdAt"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAt")
    }
  }

  public struct User: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("details", type: .object(Detail.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(details: Detail? = nil) {
      self.init(snapshot: ["__typename": "User", "details": details.flatMap { $0.snapshot }])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var details: Detail? {
      get {
        return (snapshot["details"] as? Snapshot).flatMap { Detail(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "details")
      }
    }

    public struct Detail: GraphQLSelectionSet {
      public static let possibleTypes = ["UserDetails"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("avatar", type: .scalar(String.self)),
        GraphQLField("fullName", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(avatar: String? = nil, fullName: String? = nil) {
        self.init(snapshot: ["__typename": "UserDetails", "avatar": avatar, "fullName": fullName])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var avatar: String? {
        get {
          return snapshot["avatar"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "avatar")
        }
      }

      public var fullName: String? {
        get {
          return snapshot["fullName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fullName")
        }
      }
    }
  }
}

public struct ConversationDetail: GraphQLFragment {
  public static let fragmentString =
    "fragment ConversationDetail on Conversation {\n  __typename\n  _id\n  content\n  createdAt\n  messages {\n    __typename\n    customerId\n    createdAt\n  }\n  status\n  readUserIds\n  participatedUsers {\n    __typename\n    _id\n    details {\n      __typename\n      fullName\n      avatar\n    }\n  }\n}"

  public static let possibleTypes = ["Conversation"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("content", type: .scalar(String.self)),
    GraphQLField("createdAt", type: .scalar(String.self)),
    GraphQLField("messages", type: .list(.object(Message.selections))),
    GraphQLField("status", type: .nonNull(.scalar(String.self))),
    GraphQLField("readUserIds", type: .list(.scalar(String.self))),
    GraphQLField("participatedUsers", type: .list(.object(ParticipatedUser.selections))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: String, content: String? = nil, createdAt: String? = nil, messages: [Message?]? = nil, status: String, readUserIds: [String?]? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
    self.init(snapshot: ["__typename": "Conversation", "_id": id, "content": content, "createdAt": createdAt, "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "status": status, "readUserIds": readUserIds, "participatedUsers": participatedUsers.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return snapshot["_id"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "_id")
    }
  }

  public var content: String? {
    get {
      return snapshot["content"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: String? {
    get {
      return snapshot["createdAt"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var messages: [Message?]? {
    get {
      return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
    }
    set {
      snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
    }
  }

  public var status: String {
    get {
      return snapshot["status"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "status")
    }
  }

  public var readUserIds: [String?]? {
    get {
      return snapshot["readUserIds"] as? [String?]
    }
    set {
      snapshot.updateValue(newValue, forKey: "readUserIds")
    }
  }

  public var participatedUsers: [ParticipatedUser?]? {
    get {
      return (snapshot["participatedUsers"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { ParticipatedUser(snapshot: $0) } } }
    }
    set {
      snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "participatedUsers")
    }
  }

  public struct Message: GraphQLSelectionSet {
    public static let possibleTypes = ["ConversationMessage"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("customerId", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(customerId: String? = nil, createdAt: String? = nil) {
      self.init(snapshot: ["__typename": "ConversationMessage", "customerId": customerId, "createdAt": createdAt])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var customerId: String? {
      get {
        return snapshot["customerId"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "customerId")
      }
    }

    public var createdAt: String? {
      get {
        return snapshot["createdAt"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "createdAt")
      }
    }
  }

  public struct ParticipatedUser: GraphQLSelectionSet {
    public static let possibleTypes = ["User"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("_id", type: .nonNull(.scalar(String.self))),
      GraphQLField("details", type: .object(Detail.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(id: String, details: Detail? = nil) {
      self.init(snapshot: ["__typename": "User", "_id": id, "details": details.flatMap { $0.snapshot }])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: String {
      get {
        return snapshot["_id"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "_id")
      }
    }

    public var details: Detail? {
      get {
        return (snapshot["details"] as? Snapshot).flatMap { Detail(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "details")
      }
    }

    public struct Detail: GraphQLSelectionSet {
      public static let possibleTypes = ["UserDetails"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("fullName", type: .scalar(String.self)),
        GraphQLField("avatar", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(fullName: String? = nil, avatar: String? = nil) {
        self.init(snapshot: ["__typename": "UserDetails", "fullName": fullName, "avatar": avatar])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fullName: String? {
        get {
          return snapshot["fullName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "fullName")
        }
      }

      public var avatar: String? {
        get {
          return snapshot["avatar"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "avatar")
        }
      }
    }
  }
}