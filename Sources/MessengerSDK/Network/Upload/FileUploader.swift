import Foundation
import UIKit

public struct UploadedAttachment {
    public let url: String
    public let name: String
    public let type: String
    public let size: Int
}

enum UploadError: LocalizedError {
    case unsupportedFormat
    case uploadFailed(String)
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .unsupportedFormat:   return "Only PNG and JPG images can be uploaded."
        case .uploadFailed(let m): return "Upload failed: \(m)"
        case .emptyResponse:       return "Server returned an empty file key."
        }
    }
}

/// Uploads a file to the messenger gateway's /upload-file endpoint.
/// Mirrors RN SDK's uploadFile() in utils/upload.ts.
final class FileUploader {
    static let shared = FileUploader()
    private init() {}

    private let allowedMimeTypes: Set<String> = ["image/png", "image/jpeg"]

    func upload(imageData: Data, filename: String, mimeType: String, fileEndpoint: String) async throws -> UploadedAttachment {
        guard allowedMimeTypes.contains(mimeType.lowercased()) else {
            throw UploadError.unsupportedFormat
        }

        let base = fileEndpoint.hasSuffix("/") ? String(fileEndpoint.dropLast()) : fileEndpoint
        guard let url = URL(string: "\(base)/gateway/upload-file?kind=main&maxHeight=0&maxWidth=0") else {
            throw UploadError.uploadFailed("Invalid endpoint URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8)?.prefix(200) ?? "unknown"
            throw UploadError.uploadFailed(String(msg))
        }

        guard let key = String(data: data, encoding: .utf8), !key.isEmpty else {
            throw UploadError.emptyResponse
        }

        return UploadedAttachment(
            url: key,
            name: filename,
            type: mimeType,
            size: imageData.count
        )
    }
}
