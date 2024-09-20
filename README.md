# SwiftUI View Hosting Framework

[![Swift](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml/badge.svg)](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml)

## Introduction

This framework provides a streamlined solution for testing SwiftUI views, with a focus on hosting views and accessing their state during tests. It offers tools for hosting SwiftUI components and injecting callbacks, enabling developers to verify the correctness and behavior of their user interfaces.

## Key Features

- **View Hosting**: APIs for hosting views during tests, ensuring controlled testing environments.
- **State Access**: Easily access and verify view state during tests.
- **Dynamic Property Testing**: Support for testing views with `@State`, `@Binding`, and other property wrappers.
- **Asynchronous Testing**: Support for testing asynchronous operations in SwiftUI views.

## Important Note

This package relies on an undocumented trick in SwiftUI:

```swift
private func host(content: () -> any View) {
    _ = _PreviewHost.makeHost(content: content()).previews
}
```

This implementation detail may be subject to change in future SwiftUI updates.

## Installation

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/sisoje/swiftui-view-hosting.git", from: "1.0.0")
]
```

Then, add the following products to your targets:

- Add `ViewHosting` to your production code target.
- Add `ViewHostingInternal` to your unit testing target.

Import the framework in your files:

```swift
import ViewHosting // In production code
import ViewHostingInternal // In test code
```

## Usage Guide

### Defining a View

When defining your view, use the `@OnBody` property wrapper:

```swift
struct MyView: View {
    @OnBody<Self> private var onBody
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
    @OnBody<Self> var onBody
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

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository and create your branch from `main`.
2. Ensure your code follows the existing style and architecture.
3. Write unit tests for your changes.
4. Run all tests to ensure they pass.
5. Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
