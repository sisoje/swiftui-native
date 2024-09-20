import SwiftUI
@testable import ViewHostingApp

extension View {
    func hosted(timeout: TimeInterval = 1) async throws -> Self {
        try await Self.hosted(timeout: timeout) { self }
    }

    @discardableResult static func onBodyPosting(timeout: TimeInterval = 1) async throws -> Self {
        try await NotificationCenter.default.observeBodyPosting(timeout: timeout)
    }

    static func hosted(timeout: TimeInterval = 1, content: @escaping () -> any View) async throws -> Self {
        Task {
            content().host()
        }
        return try await onBodyPosting(timeout: timeout)
    }

    func host() {
        _ = _PreviewHost.makeHost(content: self).previews
    }
}
