# MessengerSDK - iOS

MessengerSDK is a secure, lightweight, and customizable iOS SDK that lets you embed a fully-featured customer messenger into your iOS application. Built on Swift and SwiftUI, it connects to the erxes platform and gives your users real-time chat, AI agent support, knowledge base access, and more — all inside your app.

<a href="https://docs.erxes.io/docs/intro">Documentation</a> <b>| </b> <a href="https://discord.com/invite/aaGzy3gQK5">Join our community</a>

## Status

<p align="center">
  <a href="./LICENSE">
    <img alt="License Badge" src="https://img.shields.io/badge/license-AGPLv3-brightgreen">
  </a>
  <a href="#">
    <img alt="iOS 16+" src="https://img.shields.io/badge/iOS-16%2B-blue">
  </a>
  <a href="#">
    <img alt="Swift 5.9+" src="https://img.shields.io/badge/Swift-5.9%2B-orange">
  </a>
  <a href="#">
    <img alt="SPM Compatible" src="https://img.shields.io/badge/SPM-compatible-brightgreen">
  </a>
  <a href="https://discord.com/invite/aaGzy3gQK5">
    <img alt="Discord" src="https://img.shields.io/badge/Discord-Community-blueviolet">
  </a>
  <a href="https://twitter.com/erxeshq">
    <img alt="Twitter" src="https://img.shields.io/badge/twitter-blue">
  </a>
</p>

<p align="center">
  <img src="screenshots/home.png" width="220" alt="Home">
  <img src="screenshots/messages.png" width="220" alt="Messages">
  <img src="screenshots/tickets.png" width="220" alt="Tickets">
</p>

## Features

- **Real-time Messenger** — Live chat powered by WebSocket with automatic reconnection and exponential backoff
- **AI Agent Support** — Integrated bot conversations with typing indicators and persistent menus
- **Floating Launcher Button** — Draggable `MessengerLaunchButton` that snaps to top-right or bottom-right corner
- **Attachment Uploads** — Photo picker with upload progress thumbnails shown inline before the message sends
- **Instagram-style Timestamps** — Swipe left to reveal per-message timestamps without leaving the conversation
- **Knowledge Base & FAQ** — Browse and search your erxes knowledge base articles in-app
- **Tickets** — Create and track support tickets directly from the messenger
- **Offline Caching** — `CachedAsyncImage` with NSCache + off-thread ImageIO downsampling; no UI-thread decode
- **Keyboard Native** — Zero-lag keyboard avoidance via `.safeAreaInset`; no custom `KeyboardObserver`

## Requirements

**Platform:**
- iOS 16.0+
- Xcode 15+

**Swift:**
- Swift 5.9+

**Dependencies (resolved via SPM):**
- [Apollo iOS](https://github.com/apollographql/apollo-ios) `>= 1.0.0`
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) `>= 3.0.0`

**erxes backend:**
- A running erxes instance with a configured Messenger integration
- Your `integrationId` and server URL from the erxes admin panel

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…** and enter:

```
https://github.com/erxes/erxes-ios-sdk
```

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/erxes/erxes-ios-sdk", from: "0.30.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["MessengerSDK"]
    )
]
```

## Getting Started

### 1. Configure the SDK

Call this once at app launch (e.g. in your `App` initializer or `AppDelegate`):

```swift
import MessengerSDK

MessengerSDK.configure(
    MessengerConfig(
        endpoint: "https://your.erxes.instance",
        integrationId: "YOUR_INTEGRATION_ID"
    )
)
```

### 2. Identify the user (optional)

```swift
MessengerSDK.setUser(MessengerUser(
    email: "user@example.com",
    name: "Jane Doe"
))
```

### 3. Add the floating launcher button

The easiest way to expose the messenger is the draggable `MessengerLaunchButton`. Drop it as an overlay on your root view:

```swift
import MessengerSDK

struct ContentView: View {
    @ObservedObject private var sdk = MessengerSDK.shared

    var body: some View {
        YourRootView()
            .overlay {
                if sdk.isReady {
                    MessengerLaunchButton()
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: sdk.isReady)
    }
}
```

The button snaps to the top-right or bottom-right corner — users can drag it between the two positions.

### 4. Or float the launcher from a UIKit / non-SwiftUI host

If your app isn't SwiftUI (UIKit, React Native, Flutter), call `showLauncher()` to float the same draggable button in a transparent overlay window above your content. Touches outside the button pass straight through, and it appears automatically once the connect handshake succeeds.

```swift
MessengerSDK.showLauncher()   // e.g. in AppDelegate / SceneDelegate after configure()
MessengerSDK.hideLauncher()   // remove it (e.g. on logout)
```

### 5. Or open the messenger programmatically

```swift
MessengerSDK.showMessenger(from: yourViewController)
```

## Contributing

Please read our [contributing guide](./CONTRIBUTING.md) and [code of conduct](./CODE_OF_CONDUCT.md) before submitting a Pull Request to the project. To report a security issue, see our [security policy](./SECURITY.md).

## Community Support

For general help using erxes, please refer to the [erxes documentation](https://docs.erxes.io). For additional help, you can use one of these channels:

- **[Discord](https://discord.com/invite/aaGzy3gQK5)** — Live discussion with the community
- **[GitHub](https://github.com/erxes/erxes-ios-sdk)** — Bug reports and contributions
- **[Feedback / Issues](https://github.com/erxes/erxes-ios-sdk/issues)** — Feature requests and bug reports
- **[Twitter](https://twitter.com/erxeshq)** — Get the news fast

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPLv3). See the [LICENSE](./LICENSE) file for licensing information.
