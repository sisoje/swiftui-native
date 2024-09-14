import SwiftUI
@testable import ViewHostingApp

@MainActor extension View {
    func hosted(timeout: TimeInterval = 1) async throws -> Self {
        try await Self.hosted(timeout: timeout) { self }
    }

    @discardableResult static func onUpdate(timeout: TimeInterval = 1) async throws -> Self {
        try await NotificationCenter.default.observeBodyEvaluation(timeout: timeout)
    }

    static func hosted(timeout: TimeInterval = 1, content: () -> any View) async throws -> Self {
        content().host()
        return try await onUpdate(timeout: timeout)
    }

    func host() {
        ViewHostingApp.shared.view = id(UUID())
    }
}
