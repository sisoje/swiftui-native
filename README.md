# SwiftUI View Hosting Framework

[![Swift](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml/badge.svg)](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml)

- Requires Xcode 16
- Builds using swift6 without any issues.
- Supports all Apple platforms: `[.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)]`

## Introduction

This framework provides a streamlined solution for **unit** testing SwiftUI views and dynamic properties, with a focus on hosting views and accessing their state during tests. It offers tools for hosting SwiftUI components and injecting callbacks, enabling developers to verify the correctness and behavior of their user interfaces.

## Package Structure

This package consists of two main products:

1. **ViewHosting**: This product is intended for use in your production code. It contains the necessary components to make your SwiftUI views testable.

2. **ViewHostingTesting**: This product is designed for use in your test target. It provides the tools needed to host views and test dynamic properties like `@State`, `@Binding`, and others in a controlled testing environment.

## Key Features

- **View Hosting**: APIs for hosting views during tests, ensuring controlled testing environments.
- **State Access**: Easily access and verify view state during tests.
- **Dynamic Property Testing**: Support for testing views with `@State`, `@Binding`, and other property wrappers.
- **Asynchronous Testing**: Support for testing asynchronous operations in SwiftUI views.

## Installation

To use this package, add the following products to your targets:

- Add `ViewHosting` to your production code target. This will make your views testable.
- Add `ViewHostingTesting` to your unit testing target. This provides the tools for hosting and testing your views.

Import the appropriate framework in your files:

```swift
import ViewHosting // In production code
@testable import ViewHostingTesting // In test code
```

## Usage Guide

### Defining a View

When defining your view, use the `@Environment(\.onBody)` environment value and ensure it behaves correctly:

```swift
struct MyView: View {
    @Environment(\.onBody) private var onBody
    @State private var text = ""

    var body: some View {
        let _ = onBody(self)
        TextField("Enter text", text: $text)
    }
}
```

### Hosting and Testing a View

To host and test a view:

```swift
func testMyView() async throws {
    let view = try await ViewHosting<MyView>().hosted {
        MyView()
    }

    XCTAssertEqual(view.text, "")
    view.text = "Hello, World!"
    XCTAssertEqual(view.text, "Hello, World!")
}
```

### Testing Dynamic Properties

You can test dynamic properties independently:

```swift
func testDynamicProperty() async throws {
    let state = try await State(initialValue: 0).hosted()
    XCTAssertEqual(state.wrappedValue, 0)
    state.wrappedValue += 1
    XCTAssertEqual(state.wrappedValue, 1)
}
```

### Handling Asynchronous Operations

For views with asynchronous operations:

```swift
struct AsyncView: View {
    @Environment(\.onBody) var onBody
    @State var text = ""
    
    func load() async {
        await MainActor.run {
            text = "loaded"
        }
    }

    var body: some View {
        let _ = onBody(self)
        Text(text)
    }
}

func testAsyncView() async throws {
    let view = try await ViewHosting<AsyncView>().hosted {
        AsyncView()
    }
    XCTAssertEqual(view.text, "")
    await view.load()
    XCTAssertEqual(view.text, "loaded")
}
```

## Advanced Features

- **ViewHosting**: The `ViewHosting` struct manages the hosting and callback injection process.
- **OnBody Property Wrapper**: `@OnBody` is used within views to enable state access during tests.
- **Error Handling**: The framework includes custom error types for handling timeouts and missing views.

## Important Note

This package currently relies on an undocumented trick in SwiftUI:

```swift
static func host(content: () -> any View) {
    _ = _PreviewHost.makeHost(content: content()).previews
}
```

While this implementation detail may be subject to change in future SwiftUI updates, it's important to note that there are alternative methods for hosting views that could be implemented if needed:

1. **UIHostingController/NSHostingController**: These platform-specific hosting controllers can be used to integrate SwiftUI views into a UIKit or AppKit environment.
2. **Dedicated Hosting App**: A separate app could be created specifically for testing, which would integrate test views into its view hierarchy.

These alternatives ensure that even if the current method becomes unavailable, the core functionality of this package can be maintained through other hosting techniques. The package's design allows for relatively easy adaptation to new hosting methods if required.

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository and create your branch from `main`.
2. Ensure your code follows the existing style and architecture.
3. Write unit tests for your changes.
4. Run all tests to ensure they pass.
5. Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
