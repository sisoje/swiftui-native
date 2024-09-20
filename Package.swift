// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ViewHosting",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)],
    products: [
        .library(
            name: "ViewHostingApp",
            targets: ["ViewHostingApp"]
        ),
        .library(
            name: "ViewHostingTests",
            targets: ["ViewHostingTests"]
        ),
    ],
    targets: [
        .target(
            name: "ViewHostingApp",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "ViewHostingTests",
            dependencies: ["ViewHostingApp"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["ViewHostingTests"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
    ]
)
