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
            return graphQLMap["size"] as! Swift.Optional<Double?>
        }
        set {
            graphQLMap.updateValue(newValue, forKey: "size")
        }
    }
}

public final class TotalUnreadCountQuery: GraphQLQuery {
    public let operationDefinition =
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
        
        public private(set) var resultMap: ResultMap
        
        public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
        }
        
        public init(totalUnreadCount: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "Query", "totalUnreadCount": totalUnreadCount])
        }
        
        public var totalUnreadCount: Int? {
            get {
                return resultMap["totalUnreadCount"] as? Int
            }
            set {
                resultMap.updateValue(newValue, forKey: "totalUnreadCount")
            }
        }
    }
}

public final class UnreadCountQuery: GraphQLQuery {
    public let operationDefinition =
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

public final class MessagesQuery: GraphQLQuery {
    public let operationDefinition =
    "query Messages($conversationId: String!) {\n  messages(conversationId: $conversationId) {\n    __typename\n    _id\n    user {\n      __typename\n      details {\n        __typename\n        avatar\n        fullName\n      }\n    }\n    customerId\n    content\n    createdAt\n    attachments {\n      __typename\n      url\n      name\n      type\n      size\n    }\n  }\n}"
    
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
                GraphQLField("_id", type: .nonNull(.scalar(String.self))),
                GraphQLField("user", type: .object(User.selections)),
                GraphQLField("customerId", type: .scalar(String.self)),
                GraphQLField("content", type: .scalar(String.self)),
                GraphQLField("createdAt", type: .scalar(Int.self)),
                GraphQLField("attachments", type: .list(.object(Attachment.selections))),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(id: String, user: User? = nil, customerId: String? = nil, content: String? = nil, createdAt: Int? = nil, attachments: [Attachment?]? = nil) {
                self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": id, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "customerId": customerId, "content": content, "createdAt": createdAt, "attachments": attachments.flatMap { (value: [Attachment?]) -> [ResultMap?] in value.map { (value: Attachment?) -> ResultMap? in value.flatMap { (value: Attachment) -> ResultMap in value.resultMap } } }])
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
            
            public var createdAt: Int? {
                get {
                    return resultMap["createdAt"] as? Int
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
                        GraphQLField("avatar", type: .scalar(String.self)),
                        GraphQLField("fullName", type: .scalar(String.self)),
                    ]
                    
                    public private(set) var resultMap: ResultMap
                    
                    public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                    }
                    
                    public init(avatar: String? = nil, fullName: String? = nil) {
                        self.init(unsafeResultMap: ["__typename": "UserDetails", "avatar": avatar, "fullName": fullName])
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
    }
}

public final class ConversationsQuery: GraphQLQuery {
    public let operationDefinition =
    "query Conversations($integrationId: String!, $customerId: String!) {\n  conversations(integrationId: $integrationId, customerId: $customerId) {\n    __typename\n    _id\n    content\n    createdAt\n    messages {\n      __typename\n      customerId\n      createdAt\n    }\n    status\n    readUserIds\n    participatedUsers {\n      __typename\n      _id\n      details {\n        __typename\n        fullName\n        avatar\n      }\n    }\n  }\n}"
    
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
                GraphQLField("_id", type: .nonNull(.scalar(String.self))),
                GraphQLField("content", type: .scalar(String.self)),
                GraphQLField("createdAt", type: .scalar(Int.self)),
                GraphQLField("messages", type: .list(.object(Message.selections))),
                GraphQLField("status", type: .nonNull(.scalar(String.self))),
                GraphQLField("readUserIds", type: .list(.scalar(String.self))),
                GraphQLField("participatedUsers", type: .list(.object(ParticipatedUser.selections))),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(id: String, content: String? = nil, createdAt: Int? = nil, messages: [Message?]? = nil, status: String, readUserIds: [String?]? = nil, participatedUsers: [ParticipatedUser?]? = nil) {
                self.init(unsafeResultMap: ["__typename": "Conversation", "_id": id, "content": content, "createdAt": createdAt, "messages": messages.flatMap { (value: [Message?]) -> [ResultMap?] in value.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } } }, "status": status, "readUserIds": readUserIds, "participatedUsers": participatedUsers.flatMap { (value: [ParticipatedUser?]) -> [ResultMap?] in value.map { (value: ParticipatedUser?) -> ResultMap? in value.flatMap { (value: ParticipatedUser) -> ResultMap in value.resultMap } } }])
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
            
            public var createdAt: Int? {
                get {
                    return resultMap["createdAt"] as? Int
                }
                set {
                    resultMap.updateValue(newValue, forKey: "createdAt")
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
            
            public var status: String {
                get {
                    return resultMap["status"]! as! String
                }
                set {
                    resultMap.updateValue(newValue, forKey: "status")
                }
            }
            
            public var readUserIds: [String?]? {
                get {
                    return resultMap["readUserIds"] as? [String?]
                }
                set {
                    resultMap.updateValue(newValue, forKey: "readUserIds")
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
                public static let possibleTypes = ["ConversationMessage"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("customerId", type: .scalar(String.self)),
                    GraphQLField("createdAt", type: .scalar(Int.self)),
                ]
                
                public private(set) var resultMap: ResultMap
                
                public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                }
                
                public init(customerId: String? = nil, createdAt: Int? = nil) {
                    self.init(unsafeResultMap: ["__typename": "ConversationMessage", "customerId": customerId, "createdAt": createdAt])
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
                
                public var createdAt: Int? {
                    get {
                        return resultMap["createdAt"] as? Int
                    }
                    set {
                        resultMap.updateValue(newValue, forKey: "createdAt")
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
                
                public private(set) var resultMap: ResultMap
                
                public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                }
                
                public init(id: String, details: Detail? = nil) {
                    self.init(unsafeResultMap: ["__typename": "User", "_id": id, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }])
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
        }
    }
}

public final class ConversationDetailQuery: GraphQLQuery {
    public let operationDefinition =
    "query ConversationDetail($id: String, $integrationId: String!) {\n  conversationDetail(_id: $id, integrationId: $integrationId) {\n    __typename\n    isOnline\n    supporters {\n      __typename\n      _id\n      details {\n        __typename\n        avatar\n        fullName\n      }\n    }\n  }\n}"
    
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
                GraphQLField("isOnline", type: .scalar(Bool.self)),
                GraphQLField("supporters", type: .list(.object(Supporter.selections))),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(isOnline: Bool? = nil, supporters: [Supporter?]? = nil) {
                self.init(unsafeResultMap: ["__typename": "ConversationDetailResponse", "isOnline": isOnline, "supporters": supporters.flatMap { (value: [Supporter?]) -> [ResultMap?] in value.map { (value: Supporter?) -> ResultMap? in value.flatMap { (value: Supporter) -> ResultMap in value.resultMap } } }])
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
            
            public var supporters: [Supporter?]? {
                get {
                    return (resultMap["supporters"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Supporter?] in value.map { (value: ResultMap?) -> Supporter? in value.flatMap { (value: ResultMap) -> Supporter in Supporter(unsafeResultMap: value) } } }
                }
                set {
                    resultMap.updateValue(newValue.flatMap { (value: [Supporter?]) -> [ResultMap?] in value.map { (value: Supporter?) -> ResultMap? in value.flatMap { (value: Supporter) -> ResultMap in value.resultMap } } }, forKey: "supporters")
                }
            }
            
            public struct Supporter: GraphQLSelectionSet {
                public static let possibleTypes = ["User"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("details", type: .object(Detail.selections)),
                ]
                
                public private(set) var resultMap: ResultMap
                
                public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                }
                
                public init(id: String, details: Detail? = nil) {
                    self.init(unsafeResultMap: ["__typename": "User", "_id": id, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }])
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
                        GraphQLField("avatar", type: .scalar(String.self)),
                        GraphQLField("fullName", type: .scalar(String.self)),
                    ]
                    
                    public private(set) var resultMap: ResultMap
                    
                    public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                    }
                    
                    public init(avatar: String? = nil, fullName: String? = nil) {
                        self.init(unsafeResultMap: ["__typename": "UserDetails", "avatar": avatar, "fullName": fullName])
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
                }
            }
        }
    }
}

public final class GetConfigQuery: GraphQLQuery {
    public let operationDefinition =
    "query GetConfig($brandCode: String!) {\n  getMessengerIntegration(brandCode: $brandCode) {\n    __typename\n    languageCode\n    uiOptions\n    messengerData\n  }\n}"
    
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
                GraphQLField("languageCode", type: .scalar(String.self)),
                GraphQLField("uiOptions", type: .scalar(JSON.self)),
                GraphQLField("messengerData", type: .scalar(JSON.self)),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(languageCode: String? = nil, uiOptions: JSON? = nil, messengerData: JSON? = nil) {
                self.init(unsafeResultMap: ["__typename": "Integration", "languageCode": languageCode, "uiOptions": uiOptions, "messengerData": messengerData])
            }
            
            public var __typename: String {
                get {
                    return resultMap["__typename"]! as! String
                }
                set {
                    resultMap.updateValue(newValue, forKey: "__typename")
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
            
            public var uiOptions: JSON? {
                get {
                    return resultMap["uiOptions"] as? JSON
                }
                set {
                    resultMap.updateValue(newValue, forKey: "uiOptions")
                }
            }
            
            public var messengerData: JSON? {
                get {
                    return resultMap["messengerData"] as? JSON
                }
                set {
                    resultMap.updateValue(newValue, forKey: "messengerData")
                }
            }
        }
    }
}

public final class GetSupportersQuery: GraphQLQuery {
    public let operationDefinition =
    "query GetSupporters($integrationId: String!) {\n  messengerSupporters(integrationId: $integrationId) {\n    __typename\n    _id\n    details {\n      __typename\n      avatar\n      shortName\n      position\n      location\n      description\n      fullName\n    }\n  }\n}"
    
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
                GraphQLField("_id", type: .nonNull(.scalar(String.self))),
                GraphQLField("details", type: .object(Detail.selections)),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(id: String, details: Detail? = nil) {
                self.init(unsafeResultMap: ["__typename": "User", "_id": id, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }])
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
                    GraphQLField("avatar", type: .scalar(String.self)),
                    GraphQLField("shortName", type: .scalar(String.self)),
                    GraphQLField("position", type: .scalar(String.self)),
                    GraphQLField("location", type: .scalar(String.self)),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("fullName", type: .scalar(String.self)),
                ]
                
                public private(set) var resultMap: ResultMap
                
                public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                }
                
                public init(avatar: String? = nil, shortName: String? = nil, position: String? = nil, location: String? = nil, description: String? = nil, fullName: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "UserDetails", "avatar": avatar, "shortName": shortName, "position": position, "location": location, "description": description, "fullName": fullName])
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
                
                public var shortName: String? {
                    get {
                        return resultMap["shortName"] as? String
                    }
                    set {
                        resultMap.updateValue(newValue, forKey: "shortName")
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
                
                public var location: String? {
                    get {
                        return resultMap["location"] as? String
                    }
                    set {
                        resultMap.updateValue(newValue, forKey: "location")
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
                
                public var fullName: String? {
                    get {
                        return resultMap["fullName"] as? String
                    }
                    set {
                        resultMap.updateValue(newValue, forKey: "fullName")
                    }
                }
            }
        }
    }
}

public final class ConnectMutation: GraphQLMutation {
    public let operationDefinition =
    "mutation Connect($brandCode: String!, $email: String, $phone: String, $isUser: Boolean!, $data: JSON) {\n  messengerConnect(brandCode: $brandCode, email: $email, phone: $phone, isUser: $isUser, data: $data) {\n    __typename\n    integrationId\n    messengerData\n    uiOptions\n    customerId\n  }\n}"
    
    public var brandCode: String
    public var email: String?
    public var phone: String?
    public var isUser: Bool
    public var data: JSON?
    
    public init(brandCode: String, email: String? = nil, phone: String? = nil, isUser: Bool, data: JSON? = nil) {
        self.brandCode = brandCode
        self.email = email
        self.phone = phone
        self.isUser = isUser
        self.data = data
    }
    
    public var variables: GraphQLMap? {
        return ["brandCode": brandCode, "email": email, "phone": phone, "isUser": isUser, "data": data]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("messengerConnect", arguments: ["brandCode": GraphQLVariable("brandCode"), "email": GraphQLVariable("email"), "phone": GraphQLVariable("phone"), "isUser": GraphQLVariable("isUser"), "data": GraphQLVariable("data")], type: .object(MessengerConnect.selections)),
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
                GraphQLField("integrationId", type: .scalar(String.self)),
                GraphQLField("messengerData", type: .scalar(JSON.self)),
                GraphQLField("uiOptions", type: .scalar(JSON.self)),
                GraphQLField("customerId", type: .scalar(String.self)),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(integrationId: String? = nil, messengerData: JSON? = nil, uiOptions: JSON? = nil, customerId: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "MessengerConnectResponse", "integrationId": integrationId, "messengerData": messengerData, "uiOptions": uiOptions, "customerId": customerId])
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
            
            public var messengerData: JSON? {
                get {
                    return resultMap["messengerData"] as? JSON
                }
                set {
                    resultMap.updateValue(newValue, forKey: "messengerData")
                }
            }
            
            public var uiOptions: JSON? {
                get {
                    return resultMap["uiOptions"] as? JSON
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
        }
    }
}

public final class ReadConversationMessagesMutation: GraphQLMutation {
    public let operationDefinition =
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
            GraphQLField("readConversationMessages", arguments: ["conversationId": GraphQLVariable("conversationId")], type: .scalar(JSON.self)),
        ]
        
        public private(set) var resultMap: ResultMap
        
        public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
        }
        
        public init(readConversationMessages: JSON? = nil) {
            self.init(unsafeResultMap: ["__typename": "Mutation", "readConversationMessages": readConversationMessages])
        }
        
        public var readConversationMessages: JSON? {
            get {
                return resultMap["readConversationMessages"] as? JSON
            }
            set {
                resultMap.updateValue(newValue, forKey: "readConversationMessages")
            }
        }
    }
}

public final class InsertMessageMutation: GraphQLMutation {
    public let operationDefinition =
    "mutation insertMessage($integrationId: String!, $customerId: String!, $message: String, $conversationId: String, $attachments: [AttachmentInput]) {\n  insertMessage(integrationId: $integrationId, customerId: $customerId, message: $message, conversationId: $conversationId, attachments: $attachments) {\n    __typename\n    _id\n    conversationId\n  }\n}"
    
    public var integrationId: String
    public var customerId: String
    public var message: String?
    public var conversationId: String?
    public var attachments: [AttachmentInput?]?
    
    public init(integrationId: String, customerId: String, message: String? = nil, conversationId: String? = nil, attachments: [AttachmentInput?]? = nil) {
        self.integrationId = integrationId
        self.customerId = customerId
        self.message = message
        self.conversationId = conversationId
        self.attachments = attachments
    }
    
    public var variables: GraphQLMap? {
        return ["integrationId": integrationId, "customerId": customerId, "message": message, "conversationId": conversationId, "attachments": attachments]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Mutation"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("insertMessage", arguments: ["integrationId": GraphQLVariable("integrationId"), "customerId": GraphQLVariable("customerId"), "message": GraphQLVariable("message"), "conversationId": GraphQLVariable("conversationId"), "attachments": GraphQLVariable("attachments")], type: .object(InsertMessage.selections)),
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
                GraphQLField("_id", type: .nonNull(.scalar(String.self))),
                GraphQLField("conversationId", type: .nonNull(.scalar(String.self))),
            ]
            
            public private(set) var resultMap: ResultMap
            
            public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
            }
            
            public init(id: String, conversationId: String) {
                self.init(unsafeResultMap: ["__typename": "ConversationMessage", "_id": id, "conversationId": conversationId])
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
        }
    }
}
