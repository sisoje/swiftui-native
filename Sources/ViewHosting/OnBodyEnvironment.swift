import SwiftUI

public extension EnvironmentValues {
    /// Injects a callback for the current view instance.
    ///
    /// Usage:
    /// ```swift
    /// @Environment(\.onBody) private var onBody
    ///
    /// var body: some View {
    ///     let _ = onBody(self)
    ///     // ... view content
    /// }
    /// ```
    ///
    /// - Production: No-op (zero overhead).
    /// - Tests: Captures view instance.
    @Entry var onBody: (any View) -> Void = { _ in }
}
