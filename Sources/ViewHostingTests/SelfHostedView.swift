import SwiftUI

protocol SelfHostedView: View {}

@MainActor extension SelfHostedView {
    public var body: some View {
        let _ = postBodyEvaluation()
        return EmptyView()
    }

    func hosted(timeout: TimeInterval = 1) async throws -> Self {
        try await Self.hosted(timeout: timeout) { self }
    }
}

struct EmptyHostedView: SelfHostedView {}
