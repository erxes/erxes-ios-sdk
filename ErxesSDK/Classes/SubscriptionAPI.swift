//  This file was automatically generated and should not be edited.

import Apollo

public final class ConversationMessageInsertedSubscription: GraphQLSubscription {
    /// subscription conversationMessageInserted($id: String!) {
    ///   conversationMessageInserted(_id: $id) {
    ///     __typename
    ///     ...MessageModel
    ///   }
    /// }
    public let operationDefinition =
    "subscription conversationMessageInserted($id: String!) { conversationMessageInserted(_id: $id) { __typename ...MessageModel } }"
    
    public let operationName = "conversationMessageInserted"
    
    public var queryDocument: String { return operationDefinition.appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }
    
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

public final class ConversationAdminMessageInsertedSubscription: GraphQLSubscription {
    /// subscription conversationAdminMessageInserted($customerId: String!) {
    ///   conversationAdminMessageInserted(customerId: $customerId) {
    ///     __typename
    ///     ...MessageModel
    ///   }
    /// }
    public let operationDefinition =
    "subscription conversationAdminMessageInserted($customerId: String!) { conversationAdminMessageInserted(customerId: $customerId) { __typename ...MessageModel } }"
    
    public let operationName = "conversationAdminMessageInserted"
    
    public var queryDocument: String { return operationDefinition.appending(MessageModel.fragmentDefinition).appending(UserModel.fragmentDefinition) }
    
    public var customerId: String
    
    public init(customerId: String) {
        self.customerId = customerId
    }
    
    public var variables: GraphQLMap? {
        return ["customerId": customerId]
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Subscription"]
        
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
