# SwiftUI View Hosting Framework

[![Swift](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml/badge.svg)](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml)

- Requires Xcode 16
- Builds using Swift 6 without any issues
- Supports all platforms `[.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)]`

## Introduction

This framework provides a streamlined solution for **unit** testing SwiftUI views and dynamic properties, with a focus on hosting views and accessing their state during tests. It offers tools for hosting SwiftUI components and injecting dependencies, enabling developers to verify the correctness and behavior of their user interfaces without modifying production code.

## Package Structure

This package consists of a single product:

- **ViewHosting**: This product is designed for use in your test target only. It provides the tools needed to host views and test dynamic properties like `@State`, `@Binding`, and others in a controlled testing environment.

## Key Features

- **View Hosting**: APIs for hosting views during tests, ensuring controlled testing environments.
- **State Access**: Easily access and verify view state during tests.
- **Dynamic Property Testing**: Support for testing views with `@State`, `@Binding`, and other property wrappers.
- **Dependency Injection**: Ability to inject dependencies and services during testing.
- **Non-Intrusive**: No modifications required to production code.

## Installation

To use this package, add the `ViewHosting` product to your test target in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ViewHosting.git", from: "1.0.0"),
],
targets: [
    .testTarget(
        name: "YourTestTarget",
        dependencies: ["ViewHosting"]
    ),
]
```

Then, import the framework in your test files:

```swift
import ViewHosting
import XCTest
```

## Usage Guide

### Preparing Your View for Testing

To make your view testable, conform it to the `DynamicProperty` protocol in your test file:

```swift
extension YourView: DynamicProperty {}
```

### Hosting and Testing a View

To host and test a view:

```swift
func testHostedView() async throws {
    let injectedText = UUID().uuidString
    let hosted = try TestView().hosted { view in
        view.environment(\.loadTextService) {
            injectedText
        }
    }
    await hosted.loadText()
    XCTAssertEqual(hosted.text, injectedText)
}
```

### Testing Dynamic Properties

You can test dynamic properties independently:

```swift
func testHostedState() throws {
    let state = try State(initialValue: 0).hosted()
    XCTAssertEqual(state.wrappedValue, 0)
    state.wrappedValue += 1
    XCTAssertEqual(state.wrappedValue, 1)
}
```

## Advanced Features

- **Dependency Injection**: Use the `hosted` method's modification closure to inject dependencies or modify the environment.
- **Error Handling**: The framework includes a custom `HostingError` for handling missing properties.
- **Performance Testing**: Includes performance tests for hosted views and dynamic properties.

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository and create your branch from `main`.
2. Ensure your code follows the existing style and architecture.
3. Write unit tests for your changes.
4. Run all tests to ensure they pass.
5. Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
