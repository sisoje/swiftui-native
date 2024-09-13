import SwiftUI
@testable import ViewHostingApp

extension View where Self: DynamicProperty {
    public var body: some View {
        let _ = postBodyEvaluation()
        return ProgressView()
    }
}

@MainActor extension View {
    func hosted(timeout: TimeInterval = 1) async throws -> Self {
        try await Self.hosted(timeout: timeout) { self }
    }
    
    @discardableResult static func onUpdate(timeout: TimeInterval = 1) async throws -> Self {
        try await NotificationCenter.default.observeBodyEvaluation(timeout: timeout)
    }

    static func hosted(timeout: TimeInterval = 1, content: () -> any View) async throws -> Self {
        await Self.resetHost()
        content().host()
        return try await onUpdate(timeout: timeout)
    }
    
    static func resetHost() async {
        await withCheckedContinuation { cont in
            EmptyView().onAppear {
                EmptyView().host()
            }
            .onDisappear {
                cont.resume()
            }
            .host()
        }
    }

    func host() {
        ViewHostingApp.shared.view = self
    }
}
