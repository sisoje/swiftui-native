import SwiftUI
@testable import ViewHostingApp

@MainActor extension View {
    @discardableResult static func onUpdate(timeout: TimeInterval = 1) async throws -> Self {
        try await NotificationCenter.default.observeBodyEvaluation(timeout: timeout)
    }

    static func hosted(timeout: TimeInterval = 1, content: () -> any View) async throws -> Self {
        await EmptyView().afterAppear()
        content().host()
        return try await onUpdate(timeout: timeout)
    }

    func afterAppear() async {
        await withCheckedContinuation { cont in
            task {
                await MainActor.run {
                    cont.resume()
                }
            }
            .host()
        }
    }

    func host() {
        ViewHostingApp.shared.view = self
    }
}
