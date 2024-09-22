// swift-tools-version: 5.10

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
            name: "ViewHostingInternal",
            targets: ["ViewHostingInternal"]
        ),
    ],
    targets: [
        .target(
            name: "ViewHosting",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "ViewHostingInternal",
            dependencies: ["ViewHosting"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["ViewHostingInternal"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
    ]
)
