//
//  SaasAPI.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 9/5/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Apollo
public final class ConversationMessageInsertedSaasSubscription: GraphQLSubscription {
    /// subscription conversationMessageInsertedSaas($id: String!) {
    ///   conversationMessageInserted(_id: $id) {
    ///     __typename
    ///     ...MessageSubscriptionModel
    ///   }
    /// }
    public let operationDefinition =
    "subscription conversationMessageInsertedSaas($id: String!) { conversationMessageInserted(_id: $id) { __typename ...MessageSubscriptionModel } }"
    
    public let operationName = "conversationMessageInsertedSaas"
    
    public var queryDocument: String { return operationDefinition.appending(MessageSubscriptionModel.fragmentDefinition) }
    
    public var id: String
    
    public init(id: String) {
        self.id = id
    }
    
    public var variables: GraphQLMap? {
        return ["id": id]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Subscription"]
        
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
            public static let possibleTypes = ["ConversationMessageSubscription"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(MessageSubscriptionModel.self),
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
                
                public var messageSubscriptionModel: MessageSubscriptionModel {
                    get {
                        return MessageSubscriptionModel(unsafeResultMap: resultMap)
                    }
                    set {
                        resultMap += newValue.resultMap
                    }
                }
            }
        }
    }
}

public struct MessageSubscriptionModel: GraphQLFragment {
    /// fragment MessageSubscriptionModel on ConversationMessageSubscription {
    ///   __typename
    ///   _id
    ///   user
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
    "fragment MessageSubscriptionModel on ConversationMessageSubscription { __typename _id user customerId content createdAt attachments { __typename url name type size } }"
    
    public static let possibleTypes = ["ConversationMessageSubscription"]
    
    public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .scalar(Scalar_JSON.self)),
        GraphQLField("customerId", type: .scalar(String.self)),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .scalar(Scalar_Date.self)),
        GraphQLField("attachments", type: .list(.object(Attachment.selections))),
    ]
    
    public private(set) var resultMap: ResultMap
    
    public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
    }
    
    public init(id: String, user: Scalar_JSON? = nil, customerId: String? = nil, content: String? = nil, createdAt: Scalar_Date? = nil, attachments: [Attachment?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "ConversationMessageSubscription", "_id": id, "user": user, "customerId": customerId, "content": content, "createdAt": createdAt, "attachments": attachments.flatMap { (value: [Attachment?]) -> [ResultMap?] in value.map { (value: Attachment?) -> ResultMap? in value.flatMap { (value: Attachment) -> ResultMap in value.resultMap } } }])
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
    
    public var user: Scalar_JSON? {
        get {
            return resultMap["user"] as? Scalar_JSON
        }
        set {
            resultMap.updateValue(newValue, forKey: "user")
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
    
    public struct Attachment: GraphQLSelectionSet {
        public static let possibleTypes = ["Attachment"]
        
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
