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
    dependencies: [],
    targets: [
        .target(
            name: "MessengerSDK",
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
