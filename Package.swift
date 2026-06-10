// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MessengerSDK",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MessengerSDK",
            targets: ["MessengerSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "MessengerSDK",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloWebSocket", package: "apollo-ios"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
            ],
            path: "Sources/MessengerSDK",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "MessengerSDKTests",
            dependencies: ["MessengerSDK"],
            path: "Tests/MessengerSDKTests"
        ),
    ]
)
