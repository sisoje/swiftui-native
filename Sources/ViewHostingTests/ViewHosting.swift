import SwiftUI
@testable import ViewHostingApp

@MainActor extension BodyPostingView {
    func hosted(timeout: TimeInterval = 1) async throws -> Self {
        try await Self.hosted(timeout: timeout) { self }
    }

    @discardableResult static func onBodyPosting(timeout: TimeInterval = 1) async throws -> Self {
        try await NotificationCenter.default.observeBodyPosting(timeout: timeout)
    }

    static func hosted(timeout: TimeInterval = 1, content: () -> any View) async throws -> Self {
        content().host()
        return try await onBodyPosting(timeout: timeout)
    }
}

@MainActor extension View {
    func host() {
        ViewHostingApp.shared.view = id(UUID())
    }
}
