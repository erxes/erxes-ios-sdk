import SwiftUI

// MARK: - Models

struct KBCategory: Identifiable {
    let id: String
    let title: String
    let description: String?
    let articleCount: Int
}

struct KBArticle: Identifiable {
    let id: String
    let title: String
    let content: String
    let updatedAt: Date
}

// MARK: - View

/// Three-tier knowledge base: Topic → Categories → Articles.
/// Mirrors RN SDK's Faq.tsx.
struct FAQView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = FAQViewModel()
    @State private var selectedCategory: KBCategory?
    @State private var selectedArticle: KBArticle?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let article = selectedArticle {
                    articleView(article)
                } else if let category = selectedCategory {
                    articleList(for: category)
                } else {
                    categoryList
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if selectedArticle != nil || selectedCategory != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if selectedArticle != nil { selectedArticle = nil }
                            else { selectedCategory = nil }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
            }
        }
        .onAppear { viewModel.load() }
    }

    // MARK: - Category list

    private var categoryList: some View {
        List(viewModel.categories) { category in
            Button { selectedCategory = category } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.title).font(.headline)
                        if let desc = category.description {
                            Text(desc).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                        }
                    }
                    Spacer()
                    Text("\(category.articleCount)")
                        .font(.caption).foregroundStyle(.secondary)
                    Image(systemName: "chevron.right").foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .foregroundStyle(.primary)
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Article list for a category

    private func articleList(for category: KBCategory) -> some View {
        List(viewModel.articles(for: category.id)) { article in
            Button { selectedArticle = article } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title).font(.headline)
                    Text(article.updatedAt, style: .date)
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .foregroundStyle(.primary)
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Article content

    private func articleView(_ article: KBArticle) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title).font(.title2.bold())
                // HTML content — render as plain text for now
                // TODO: use WKWebView or AttributedString HTML parsing for rich content
                Text(article.content.strippingHTML())
                    .font(.body)
            }
            .padding()
        }
    }

    private var navigationTitle: String {
        if let a = selectedArticle { return a.title }
        if let c = selectedCategory { return c.title }
        return "Help"
    }
}

// MARK: - ViewModel

@MainActor
final class FAQViewModel: ObservableObject {
    @Published var categories: [KBCategory] = []
    @Published var isLoading = false
    private var articlesByCategory: [String: [KBArticle]] = [:]

    func load() {
        isLoading = true
        // TODO: execute knowledgeBaseTopicDetail GraphQL query
        isLoading = false
    }

    func articles(for categoryId: String) -> [KBArticle] {
        articlesByCategory[categoryId] ?? []
    }
}

// MARK: - HTML strip helper

private extension String {
    func strippingHTML() -> String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil))?.string ?? self
    }
}
