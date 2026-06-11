import Foundation

@MainActor
final class HelpViewModel: ObservableObject {
    @Published var topic: KBTopic?
    @Published var isLoading = false
    @Published var error: String?

    private var hasLoaded = false

    var parentCategories: [KBCategory] { topic?.parentCategories ?? [] }

    /// Articles for a selected category — the category's own articles plus those
    /// belonging to any of its child categories (whose articles live in the flat
    /// `categories` list, keyed by `parentCategoryId`).
    func articles(for category: KBCategory) -> [KBArticle] {
        var result = category.articles
        let children = (topic?.categories ?? []).filter { $0.parentCategoryId == category.id }
        for child in children where !child.articles.isEmpty {
            result.append(contentsOf: child.articles)
        }
        // De-duplicate by id, preserving order.
        var seen = Set<String>()
        return result.filter { seen.insert($0.id).inserted }
    }

    func load(appVM: AppViewModel) {
        guard !hasLoaded else { return }
        guard let config = appVM.config, let topicId = appVM.knowledgeBaseTopicId else { return }
        hasLoaded = true
        isLoading = true
        error = nil
        Task {
            do {
                topic = try await fetchTopic(config: config, topicId: topicId)
            } catch {
                SDKLogger.error("Help topic fetch failed: \(error)")
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    // MARK: - GraphQL

    private func fetchTopic(config: MessengerConfig, topicId: String) async throws -> KBTopic {
        let query = """
        query cpKnowledgeBaseTopicDetail($_id: String!) {
          cpKnowledgeBaseTopicDetail(_id: $_id) {
            _id
            title
            description
            color
            code
            categories {
              _id
              title
              description
              numOfArticles(status: "publish")
              countArticles
              parentCategoryId
              icon
              articles(status: "publish") {
                viewCount
                topicId
                title
                summary
                status
                publishedAt
                modifiedDate
                content
                code
                categoryId
                _id
              }
            }
            parentCategories {
              _id
              title
              description
              numOfArticles(status: "publish")
              parentCategoryId
              icon
              childrens { _id }
              articles {
                viewCount
                topicId
                title
                summary
                status
                publishedAt
                modifiedDate
                content
                code
                categoryId
                _id
              }
            }
          }
        }
        """

        let obj = try await GraphQL.object(
            endpoint: config.fileEndpoint,
            operation: "cpKnowledgeBaseTopicDetail",
            query: query,
            variables: ["_id": topicId],
            field: "cpKnowledgeBaseTopicDetail"
        )

        return parseTopic(obj)
    }

    // MARK: - Parsers

    private func parseTopic(_ d: [String: Any]) -> KBTopic {
        let categories = (d["categories"] as? [[String: Any]] ?? []).compactMap(parseCategory)
        let parents = (d["parentCategories"] as? [[String: Any]] ?? []).compactMap(parseCategory)
        return KBTopic(
            id: d["_id"] as? String ?? "",
            title: d["title"] as? String ?? "Help center",
            description: d["description"] as? String,
            categories: categories,
            parentCategories: parents
        )
    }

    private func parseCategory(_ d: [String: Any]) -> KBCategory? {
        guard let id = d["_id"] as? String else { return nil }
        let childrenIds = (d["childrens"] as? [[String: Any]] ?? []).compactMap { $0["_id"] as? String }
        let articles = (d["articles"] as? [[String: Any]] ?? []).compactMap(parseArticle)
        return KBCategory(
            id: id,
            title: d["title"] as? String ?? "",
            description: d["description"] as? String,
            numOfArticles: d["numOfArticles"] as? Int ?? articles.count,
            parentCategoryId: d["parentCategoryId"] as? String,
            icon: d["icon"] as? String,
            childrenIds: childrenIds,
            articles: articles
        )
    }

    private func parseArticle(_ d: [String: Any]) -> KBArticle? {
        guard let id = d["_id"] as? String else { return nil }
        return KBArticle(
            id: id,
            title: d["title"] as? String ?? "",
            summary: d["summary"] as? String,
            content: d["content"] as? String ?? "",
            publishedAt: DateParsing.date(from: d["publishedAt"]),
            viewCount: d["viewCount"] as? Int ?? 0
        )
    }
}
