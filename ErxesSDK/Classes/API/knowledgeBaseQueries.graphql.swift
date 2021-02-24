// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class KnowledgeBaseTopicDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query knowledgeBaseTopicDetail($id: String!) {
      knowledgeBaseTopicDetail(_id: $id) {
        __typename
        ...KnowledgeBaseTopicModel
      }
    }
    """

  public let operationName: String = "knowledgeBaseTopicDetail"

  public var queryDocument: String { return operationDefinition.appending(KnowledgeBaseTopicModel.fragmentDefinition).appending(KnowledgeBaseCategoryModel.fragmentDefinition).appending(KbArticleModel.fragmentDefinition) }

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("knowledgeBaseTopicDetail", arguments: ["_id": GraphQLVariable("id")], type: .object(KnowledgeBaseTopicDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(knowledgeBaseTopicDetail: KnowledgeBaseTopicDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "knowledgeBaseTopicDetail": knowledgeBaseTopicDetail.flatMap { (value: KnowledgeBaseTopicDetail) -> ResultMap in value.resultMap }])
    }

    public var knowledgeBaseTopicDetail: KnowledgeBaseTopicDetail? {
      get {
        return (resultMap["knowledgeBaseTopicDetail"] as? ResultMap).flatMap { KnowledgeBaseTopicDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "knowledgeBaseTopicDetail")
      }
    }

    public struct KnowledgeBaseTopicDetail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["KnowledgeBaseTopic"]

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

public final class KnowledgeBaseCategoryDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query knowledgeBaseCategoryDetail($id: String!) {
      knowledgeBaseCategoryDetail(_id: $id) {
        __typename
        ...KBModel
      }
    }
    """

  public let operationName: String = "knowledgeBaseCategoryDetail"

  public var queryDocument: String { return operationDefinition.appending(KbModel.fragmentDefinition).appending(KbArticleModel.fragmentDefinition) }

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("knowledgeBaseCategoryDetail", arguments: ["_id": GraphQLVariable("id")], type: .object(KnowledgeBaseCategoryDetail.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(knowledgeBaseCategoryDetail: KnowledgeBaseCategoryDetail? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "knowledgeBaseCategoryDetail": knowledgeBaseCategoryDetail.flatMap { (value: KnowledgeBaseCategoryDetail) -> ResultMap in value.resultMap }])
    }

    public var knowledgeBaseCategoryDetail: KnowledgeBaseCategoryDetail? {
      get {
        return (resultMap["knowledgeBaseCategoryDetail"] as? ResultMap).flatMap { KnowledgeBaseCategoryDetail(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "knowledgeBaseCategoryDetail")
      }
    }

    public struct KnowledgeBaseCategoryDetail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["KnowledgeBaseCategory"]

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

public struct KnowledgeBaseTopicModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment KnowledgeBaseTopicModel on KnowledgeBaseTopic {
      __typename
      title
      description
      categories {
        __typename
        ...KnowledgeBaseCategoryModel
      }
    }
    """

  public static let possibleTypes: [String] = ["KnowledgeBaseTopic"]

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
    public static let possibleTypes: [String] = ["KnowledgeBaseCategory"]

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
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment KnowledgeBaseCategoryModel on KnowledgeBaseCategory {
      __typename
      _id
      title
      description
      numOfArticles
      icon
      articles {
        __typename
        ...KBArticleModel
      }
    }
    """

  public static let possibleTypes: [String] = ["KnowledgeBaseCategory"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("numOfArticles", type: .scalar(Double.self)),
    GraphQLField("icon", type: .scalar(String.self)),
    GraphQLField("articles", type: .list(.object(Article.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String? = nil, title: String? = nil, description: String? = nil, numOfArticles: Double? = nil, icon: String? = nil, articles: [Article?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseCategory", "_id": _id, "title": title, "description": description, "numOfArticles": numOfArticles, "icon": icon, "articles": articles.flatMap { (value: [Article?]) -> [ResultMap?] in value.map { (value: Article?) -> ResultMap? in value.flatMap { (value: Article) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var _id: String? {
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

  public var numOfArticles: Double? {
    get {
      return resultMap["numOfArticles"] as? Double
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
    public static let possibleTypes: [String] = ["KnowledgeBaseArticle"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(KbArticleModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String? = nil, title: String? = nil, summary: String? = nil, content: String? = nil, createdDate: Scalar_Date? = nil) {
      self.init(unsafeResultMap: ["__typename": "KnowledgeBaseArticle", "_id": _id, "title": title, "summary": summary, "content": content, "createdDate": createdDate])
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

public struct KbModel: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment KBModel on KnowledgeBaseCategory {
      __typename
      _id
      title
      description
      numOfArticles
      icon
      articles {
        __typename
        ...KBArticleModel
      }
    }
    """

  public static let possibleTypes: [String] = ["KnowledgeBaseCategory"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .scalar(String.self)),
    GraphQLField("title", type: .scalar(String.self)),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("numOfArticles", type: .scalar(Double.self)),
    GraphQLField("icon", type: .scalar(String.self)),
    GraphQLField("articles", type: .list(.object(Article.selections))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(_id: String? = nil, title: String? = nil, description: String? = nil, numOfArticles: Double? = nil, icon: String? = nil, articles: [Article?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseCategory", "_id": _id, "title": title, "description": description, "numOfArticles": numOfArticles, "icon": icon, "articles": articles.flatMap { (value: [Article?]) -> [ResultMap?] in value.map { (value: Article?) -> ResultMap? in value.flatMap { (value: Article) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var _id: String? {
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

  public var numOfArticles: Double? {
    get {
      return resultMap["numOfArticles"] as? Double
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
    public static let possibleTypes: [String] = ["KnowledgeBaseArticle"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(KbArticleModel.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(_id: String? = nil, title: String? = nil, summary: String? = nil, content: String? = nil, createdDate: Scalar_Date? = nil) {
      self.init(unsafeResultMap: ["__typename": "KnowledgeBaseArticle", "_id": _id, "title": title, "summary": summary, "content": content, "createdDate": createdDate])
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
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment KBArticleModel on KnowledgeBaseArticle {
      __typename
      _id
      title
      summary
      content
      createdDate
    }
    """

  public static let possibleTypes: [String] = ["KnowledgeBaseArticle"]

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

  public init(_id: String? = nil, title: String? = nil, summary: String? = nil, content: String? = nil, createdDate: Scalar_Date? = nil) {
    self.init(unsafeResultMap: ["__typename": "KnowledgeBaseArticle", "_id": _id, "title": title, "summary": summary, "content": content, "createdDate": createdDate])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var _id: String? {
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
