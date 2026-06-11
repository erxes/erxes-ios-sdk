import SwiftUI

// MARK: - Knowledge base models

/// A knowledge base category. Top-level entries (no parent) drive the Help tab's
/// landing list; child categories contribute their articles to the parent.
struct KBCategory: Identifiable {
    let id: String
    let title: String
    let description: String?
    let numOfArticles: Int
    let parentCategoryId: String?
    let icon: String?
    let childrenIds: [String]
    let articles: [KBArticle]
}

struct KBArticle: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String?
    let content: String
    let publishedAt: Date?
    let viewCount: Int
}

struct KBTopic {
    let id: String
    let title: String
    let description: String?
    let categories: [KBCategory]        // all categories, including children
    let parentCategories: [KBCategory]  // top-level categories
}

// MARK: - Help tab

/// Three-tier knowledge base: Topic → Categories → Articles → HTML content.
/// Driven by `messengerData.knowledgeBaseTopicId` and the
/// `cpKnowledgeBaseTopicDetail` query. Mirrors the RN SDK's Faq flow.
struct HelpView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = HelpViewModel()
    @State private var selectedCategory: KBCategory?

    var body: some View {
        topicLanding
            .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
            .ignoresSafeArea(edges: .top)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                viewModel.load(appVM: appVM)
                // Warm the web-content process so opening an article is instant.
                WebViewWarmer.shared.warm()
            }
            // A category opens in a sheet; inside it a NavigationStack pushes the
            // article content so it can be swiped back from the left edge.
            .sheet(item: $selectedCategory) { category in
                CategorySheet(category: category, articles: viewModel.articles(for: category))
                    .environmentObject(appVM)
            }
    }

    // MARK: - Topic landing (parent categories)

    private var topicLanding: some View {
        ScrollView {
            VStack(spacing: 0) {
                PageHeroHeader(
                    title: viewModel.topic?.title ?? "Help center",
                    subtitle: viewModel.topic?.description ?? "Browse articles and find answers"
                )
                .environmentObject(appVM)

                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 60)
                } else if let error = viewModel.error {
                    errorState(error)
                        .padding(.top, 60)
                        .padding(.horizontal, 32)
                } else if viewModel.parentCategories.isEmpty {
                    emptyState
                        .padding(.top, 60)
                        .padding(.horizontal, 32)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.parentCategories) { category in
                            categoryRow(category)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }

                Spacer().frame(height: 80)
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func categoryRow(_ category: KBCategory) -> some View {
        Button {
            selectedCategory = category
        } label: {
            HStack(spacing: 14) {
                categoryIcon(category)

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    if let desc = category.description, !desc.isEmpty {
                        Text(desc)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    Text("\(category.numOfArticles) article\(category.numOfArticles == 1 ? "" : "s")")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Color(appVM.effectivePrimaryColor))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .liquidGlassCard(cornerRadius: 20)
        }
        .buttonStyle(.plain)
    }

    /// Left "123" / icon badge. Uses the category's configured icon when it maps
    /// to an SF Symbol, otherwise a numbered-list glyph.
    private func categoryIcon(_ category: KBCategory) -> some View {
        let primary = Color(appVM.effectivePrimaryColor)
        let symbol = category.icon.flatMap { UIImage(systemName: $0) != nil ? $0 : nil }
            ?? "list.number"
        return Image(systemName: symbol)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(primary)
            .frame(width: 40, height: 40)
            .background(primary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - States

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(.secondary)
            Text("Couldn't load help")
                .font(.system(size: 18, weight: .semibold))
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(Color(appVM.effectivePrimaryColor).opacity(0.70))
                .frame(width: 84, height: 84)
                .background(Color(appVM.effectivePrimaryColor).opacity(0.08), in: Circle())
                .overlay(Circle().strokeBorder(Color(appVM.effectivePrimaryColor).opacity(0.15), lineWidth: 1))

            VStack(spacing: 8) {
                Text("Nothing here yet")
                    .font(.system(size: 18, weight: .semibold))
                Text("There are no articles published\nin this knowledge base yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
    }
}

// MARK: - Category sheet

/// A category presented as a sheet: a NavigationStack listing the category's
/// articles, where tapping one pushes the article content (swipe-back enabled).
/// Dismissed via the X button in the navigation bar.
private struct CategorySheet: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss
    let category: KBCategory
    let articles: [KBArticle]

    var body: some View {
        NavigationStack {
            Group {
                if articles.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(articles) { article in
                                NavigationLink(value: article) {
                                    articleRow(article)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        Spacer().frame(height: 40)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle(category.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: KBArticle.self) { article in
                ArticleContentView(article: article)
                    .environmentObject(appVM)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.secondary)
                            .frame(width: 30, height: 30)
                            .background(Color.primary.opacity(0.08), in: Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea())
        }
        .environment(\.colorScheme, appVM.effectiveColorScheme)
        .tint(Color(appVM.effectivePrimaryColor))
    }

    private func articleRow(_ article: KBArticle) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "doc.text")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(appVM.effectivePrimaryColor))
                .frame(width: 40, height: 40)
                .background(Color(appVM.effectivePrimaryColor).opacity(0.12),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(article.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                if let summary = article.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                if let date = article.publishedAt {
                    Text(date, style: .date)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .liquidGlassCard(cornerRadius: 20)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(.secondary)
            Text("No articles in this category yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Article content

/// Pushed article reader. The push renders instantly with a light placeholder;
/// the WKWebView is mounted just after the navigation transition settles so its
/// layout cost never blocks the tap. Swipe-from-left-edge back is provided by the
/// navigation stack.
private struct ArticleContentView: View {
    @EnvironmentObject var appVM: AppViewModel
    let article: KBArticle
    @State private var showContent = false

    var body: some View {
        ZStack {
            Color(appVM.effectiveContainerBackgroundColor).ignoresSafeArea()

            if showContent {
                HTMLContentView(
                    html: article.content,
                    textColor: appVM.effectiveLabelColor,
                    backgroundColor: appVM.effectiveContainerBackgroundColor,
                    tint: appVM.effectivePrimaryColor
                )
                .transition(.opacity)
            } else {
                ProgressView()
                    .tint(Color(appVM.effectivePrimaryColor))
            }
        }
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Let the push animation finish before mounting the web view.
            try? await Task.sleep(nanoseconds: 300_000_000)
            withAnimation(.easeIn(duration: 0.15)) { showContent = true }
        }
    }
}
