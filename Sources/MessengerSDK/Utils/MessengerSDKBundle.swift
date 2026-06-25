import Foundation

extension Bundle {
    static var messengerSDKResources: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        let candidates = [
            Bundle(for: MessengerSDKBundleToken.self).resourceURL,
            Bundle.main.resourceURL
        ]

        for candidate in candidates {
            let bundleURL = candidate?.appendingPathComponent("MessengerSDKResources.bundle")
            if let bundleURL, let bundle = Bundle(url: bundleURL) {
                return bundle
            }
        }

        return Bundle(for: MessengerSDKBundleToken.self)
        #endif
    }
}

private final class MessengerSDKBundleToken {}
