// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ErxesSDK",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ErxesSDK",
            targets: ["ErxesSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "ErxesSDK",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloWebSocket", package: "apollo-ios"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
            ],
            path: "Sources/ErxesSDK",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ErxesSDKTests",
            dependencies: ["ErxesSDK"],
            path: "Tests/ErxesSDKTests"
        ),
    ]
)
