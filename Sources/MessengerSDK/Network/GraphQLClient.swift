import Foundation

/// Shared GraphQL transport. Centralizes the endpoint URL, request construction,
/// status logging, and error handling that was previously copy-pasted across
/// every ViewModel.
enum GraphQL {

    struct GraphQLError: Error, LocalizedError {
        let message: String
        var errorDescription: String? { message }
    }

    /// The messenger gateway always lives at `/gateway/graphql` on the file endpoint
    /// (no `w.` subdomain). Strips a trailing slash before appending.
    static func url(for endpoint: String) -> URL? {
        let base = endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint
        return URL(string: "\(base)/gateway/graphql")
    }

    /// Performs a GraphQL POST and returns the full decoded top-level JSON object.
    /// Logs the HTTP status under `operation`. Throws on bad URL, transport failure,
    /// or a non-JSON response. Does NOT throw on a GraphQL `errors` array — callers
    /// that want to tolerate partial data inspect the result themselves.
    @discardableResult
    static func send(
        endpoint: String,
        operation: String,
        query: String,
        variables: [String: Any]
    ) async throws -> [String: Any] {
        guard let url = url(for: endpoint) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query": query,
            "variables": variables
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        SDKLogger.debug("\(operation) HTTP \(status)")

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        return json
    }

    /// Performs a mutation/query that must fail loudly: throws `GraphQLError` when the
    /// response carries an `errors` array, then extracts `data[field]` as an object.
    static func object(
        endpoint: String,
        operation: String,
        query: String,
        variables: [String: Any],
        field: String
    ) async throws -> [String: Any] {
        let json = try await send(endpoint: endpoint, operation: operation, query: query, variables: variables)
        if let errors = json["errors"] as? [[String: Any]], !errors.isEmpty {
            SDKLogger.error("\(operation) errors: \(errors)")
            throw GraphQLError(message: errors.first?["message"] as? String ?? "Unknown error")
        }
        guard let obj = (json["data"] as? [String: Any])?[field] as? [String: Any] else {
            throw GraphQLError(message: "Failed to parse \(field)")
        }
        return obj
    }

    /// Tolerant list fetch: logs any `errors` array but does not throw, returning the
    /// `data[field]` array or `[]` when absent. Use for screens that should still render
    /// when the backend returns partial data.
    static func array(
        endpoint: String,
        operation: String,
        query: String,
        variables: [String: Any],
        field: String
    ) async throws -> [[String: Any]] {
        let json = try await send(endpoint: endpoint, operation: operation, query: query, variables: variables)
        if let errors = json["errors"] as? [[String: Any]], !errors.isEmpty {
            SDKLogger.error("\(operation) errors: \(errors)")
        }
        return (json["data"] as? [String: Any])?[field] as? [[String: Any]] ?? []
    }
}
