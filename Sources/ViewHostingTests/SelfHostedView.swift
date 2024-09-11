import SwiftUI

protocol SelfHostedView: View {}

@MainActor extension SelfHostedView {
    public var body: some View {
        let _ = postBodyEvaluation()
#if swift(>=6.0)
        return EmptyView()
#else
        return ProgressView()
#endif
    }

    func hosted(timeout: TimeInterval = 1) async throws -> Self {
        try await Self.hosted(timeout: timeout) { self }
    }
}

struct EmptyHostedView: SelfHostedView {}
