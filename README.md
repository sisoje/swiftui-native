# SwiftUI View Hosting Framework

[![Swift](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml/badge.svg)](https://github.com/sisoje/swiftui-view-hosting/actions/workflows/swift.yml)

## Introduction

This framework provides a powerful solution for testing SwiftUI views, with a particular focus on testing views with changing state. It offers tools for hosting and observing SwiftUI components, enabling developers to verify the correctness and behavior of their user interfaces throughout the view lifecycle.

## Key Features

- **View Hosting**: APIs for hosting views during tests, ensuring controlled testing environments.
- **State Change Testing**: Easily test views with changing state, including `@State`, `@Binding`, and other property wrappers.
- **Lifecycle Event Testing**: Verify the behavior of views during different lifecycle events such as `task` and `onAppear`.
- **Asynchronous Testing**: Support for testing asynchronous operations in SwiftUI views.
- **Navigation Testing**: Capabilities to test NavigationStack and navigation flow.

## Installation

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/sisoje/swiftui-view-hosting.git", from: "1.0.0")
]
```

Then, import the frameworks in your test files:

```swift
import SwiftUI
import XCTest
@testable import ViewHostingApp
import ViewHostingTests
```

## Usage Guide

### Hosting a View

To host a view for testing:

```swift
let view = try await MyView.host { MyView() }
```

### Testing State Changes

To test state changes after an action:

```swift
let view = try await MyView.host { MyView() }
// Perform some action that should change the state
try await MyView.onUpdate()
// Assert the new state
```

### Testing Navigation

Here's an example of how to test navigation using NavigationStack:

```swift
@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
func testNavigation() async throws {
    struct One: View {
        @State var numbers: [Int] = []
        var body: some View {
            let _ = postBodyEvaluation()
            NavigationStack(path: $numbers) {
                ProgressView()
                    .navigationDestination(
                        for: Int.self,
                        destination: Two.init
                    )
            }
        }
    }
        
    struct Two: View {
        let number: Int
        var body: some View {
            let _ = postBodyEvaluation()
            Text(number.description)
        }
    }
    
    let one = try await One.host { One() }
    one.numbers.append(1)
    try await Two.onUpdate()
}
```

### Testing Task

Test asynchronous operations using the `task` modifier:

```swift
func testTask() async throws {
    struct TaskView: View {
        @State var number = 0
        var body: some View {
            let _ = postBodyEvaluation()
            Text(number.description)
                .task { number += 1 }
        }
    }
    
    let view = try await TaskView.host { TaskView() }
    XCTAssertEqual(view.number, 0)
    try await TaskView.onUpdate()
    XCTAssertEqual(view.number, 1)
}
```

## Advanced Features

- **Body Evaluation Observation**: Use `postBodyEvaluation()` in your view's body to enable state tracking.
- **Update Waiting**: Use `onUpdate()` to wait for and capture view updates.
- **Appearance Testing**: The `appear()` function allows testing of `onAppear` behavior.

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository and create your branch from `main`.
2. Ensure your code follows the existing style and architecture.
3. Write unit tests for your changes.
4. Run all tests to ensure they pass.
5. Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
