// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUINative",
    platforms:  [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)] + [.visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUINative",
            targets: ["SwiftUINative"]
        ),
        .library(
            name: "SwiftUINativeTesting",
            targets: ["SwiftUINativeTesting"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUINative",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "SwiftUINativeTesting",
            dependencies: ["SwiftUINative"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: ["SwiftUINativeTesting"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
    ]
)
