import Combine
import SwiftUI

struct ViewHosting<T: View> {
    private let currentValue = CurrentValueSubject<SendableView?, Never>(nil)
}

private extension ViewHosting {
    // This function uses SwiftUI's undocumented _PreviewHost to create a fully functional
    // SwiftUI environment. It ensures that all property wrappers are properly initialized
    // and function as they would in a real SwiftUI app context. While effective, this
    // approach relies on undocumented APIs and may need to be updated in future SwiftUI versions.
    //
    // Note: If this method becomes unavailable in future SwiftUI updates, alternative
    // hosting methods can be implemented:
    // 1. UIHostingController/NSHostingController: These platform-specific hosting controllers
    //    can be used to integrate SwiftUI views into a UIKit or AppKit environment.
    // 2. Dedicated Hosting App: A separate app could be created specifically for testing,
    //    which would integrate test views into its view hierarchy.
    //
    // These alternatives ensure that the core functionality of this package can be
    // maintained through other hosting techniques if needed.
    static func host(content: () -> any View) {
        _ = _PreviewHost.makeHost(content: content()).previews
    }
}

@MainActor extension ViewHosting {
    static func hosted(content: () -> T) async throws -> T {
        try await ViewHosting().hosted(content: content)
    }

    func hosted(content: () -> some View) async throws -> T {
        Self.host {
            content().onBody(type: T.self) {
                currentValue.send(SendableView(view: $0))
            }
        }
        guard let view = currentValue.value?.view as? T else {
            throw ViewHostingError.missing
        }
        return view
    }

    @discardableResult func onBody(timeout: TimeInterval = 1) async throws -> T {
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            currentValue.send(nil)
        }
        for await bodyEvaluation in currentValue.dropFirst().values {
            timeoutTask.cancel()
            guard let view = bodyEvaluation?.view as? T else {
                throw ViewHostingError.timeout
            }
            return view
        }
        throw ViewHostingError.timeout
    }
}
