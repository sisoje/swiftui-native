// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ViewHosting",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8), .visionOS(.v1)],
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
    ]
)
