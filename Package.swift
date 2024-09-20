// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ViewHosting",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)],
    products: [
        .library(
            name: "ViewHosting",
            targets: ["ViewHosting"]
        ),
        .library(
            name: "ViewHostingTesting",
            targets: ["ViewHostingTesting"]
        ),
    ],
    targets: [
        .target(
            name: "ViewHosting",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "ViewHostingTesting",
            dependencies: ["ViewHosting"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["ViewHostingTesting"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
    ]
)
