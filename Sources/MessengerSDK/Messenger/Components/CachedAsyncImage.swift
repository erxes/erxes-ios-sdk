import SwiftUI
import ImageIO
import UIKit

/// Drop-in replacement for SwiftUI's `AsyncImage` with three critical fixes:
///   1. **In-memory cache** — re-appearing images show instantly, no re-download.
///   2. **Background decode** — images are decoded off the main thread, so the
///      main-thread layout pass during a tab switch / sheet present never blocks
///      on image decoding (the main source of "laggy" transitions).
///   3. **Downsampling** — images are scaled to their display size via ImageIO,
///      so a 4000px avatar isn't held in memory at full resolution.
enum RemoteImageCache {
    /// Decoded, downsampled bitmaps keyed by URL. Thread-safe; evicts under pressure.
    private static let memory: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 250
        return cache
    }()

    /// URLs that already failed (404 / not an image / network error). Prevents a
    /// broken URL from being re-fetched on every re-render — the source of the
    /// idle CPU burn when an avatar URL is wrong.
    private static let failed = NSCache<NSURL, NSNumber>()

    /// Synchronous cache lookup — used to seed `@State` so a cached image renders
    /// on the very first frame with no flicker.
    static func cached(_ url: URL) -> UIImage? {
        memory.object(forKey: url as NSURL)
    }

    /// Downloads (HTTP-cached via URLSession), downsamples to `maxPixel` points,
    /// caches, and returns the bitmap. Runs entirely off the main actor.
    static func load(_ url: URL, maxPixel: CGFloat) async -> UIImage? {
        if let hit = memory.object(forKey: url as NSURL) { return hit }
        // Don't keep hammering a URL we already know is broken.
        if failed.object(forKey: url as NSURL) != nil { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let http = response as? HTTPURLResponse
            SDKLogger.debug("Image load — status=\(http?.statusCode ?? -1) type=\(http?.mimeType ?? "?") bytes=\(data.count) url=\(url.absoluteString)")
            // Treat non-2xx (e.g. an HTML 404 page) as a failure so we don't try
            // to decode it and don't retry it.
            if let http, !(200...299).contains(http.statusCode) {
                SDKLogger.error("Image load failed — non-2xx status \(http.statusCode) for \(url.absoluteString)")
                failed.setObject(1, forKey: url as NSURL)
                return nil
            }
            guard let image = downsample(data: data, maxPixel: maxPixel) ?? UIImage(data: data) else {
                SDKLogger.error("Image load failed — could not decode \(data.count) bytes (type=\(http?.mimeType ?? "?")) for \(url.absoluteString)")
                failed.setObject(1, forKey: url as NSURL)
                return nil
            }
            memory.setObject(image, forKey: url as NSURL)
            return image
        } catch is CancellationError {
            // A SwiftUI re-render cancelled the `.task`. This is transient — do NOT
            // mark the URL as failed, or it would be skipped forever and the spinner
            // would spin indefinitely. Let the next render retry.
            return nil
        } catch let urlError as URLError where urlError.code == .cancelled {
            // URLSession surfaces cancellation as URLError.cancelled, not
            // CancellationError — same handling: transient, don't blacklist.
            return nil
        } catch {
            SDKLogger.error("Image load failed — \(error.localizedDescription) for \(url.absoluteString)")
            failed.setObject(1, forKey: url as NSURL)
            return nil
        }
    }

    /// Decodes `data` into a thumbnail no larger than `maxPixel` points (×3 for
    /// retina). Uses ImageIO so the full-resolution bitmap is never materialised.
    private static func downsample(data: Data, maxPixel: CGFloat) -> UIImage? {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
            return nil
        }
        let maxDimension = maxPixel * 3   // assume retina; cheap upper bound
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,        // decode now, off main thread
            kCGImageSourceCreateThumbnailWithTransform: true,  // honor EXIF orientation
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

/// Cached, background-decoded async image. API mirrors `AsyncImage`.
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let maxPixel: CGFloat
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var image: UIImage?

    init(
        url: URL?,
        maxPixel: CGFloat = 120,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.maxPixel = maxPixel
        self.content = content
        self.placeholder = placeholder
        // Seed from cache so a previously-loaded image appears on the first frame
        // — no flicker, no reload when the row scrolls back into view.
        _image = State(initialValue: url.flatMap { RemoteImageCache.cached($0) })
    }

    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            guard image == nil, let url else { return }
            let loaded = await RemoteImageCache.load(url, maxPixel: maxPixel)
            if !Task.isCancelled { image = loaded }
        }
    }
}
