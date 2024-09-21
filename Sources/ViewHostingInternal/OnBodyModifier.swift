import SwiftUI
import ViewHosting

extension View {
    /// Adds a callback to be executed when the view's body is evaluated.
    /// This is primarily used for testing purposes to capture and interact with view instances.
    ///
    /// - Parameters:
    ///   - type: The type of view to capture. This should match the concrete type of the view you're testing.
    ///   - callback: A closure that will be called with the view instance when its body is evaluated.
    ///
    /// - Returns: A view with the onBody environment value set.
    ///
    /// - Note: This modifier should be used in conjunction with the `@Environment(\.onBody)` property wrapper
    ///         in the view being tested. The view should call `onBody(self)` in its `body`.
    func onBody<T: View>(type: T.Type, callback: @escaping (T) -> Void) -> some View {
        environment(\.onBody) { view in
            // Only execute the callback if the view matches the expected type
            if let typedView = view as? T {
                callback(typedView)
            }
            // If the view doesn't match the expected type, the callback is not executed
            // This allows for type-safe capturing of specific view instances
        }
    }
}
