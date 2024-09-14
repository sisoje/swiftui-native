import SwiftUI
@testable import ViewHostingApp

extension NotificationCenter {
    @MainActor func observeBodyEvaluation<T: View>(timeout: TimeInterval) async throws -> T {
        // normally we get notification immediately but if there is any problem we dont want to wait forever
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            // if timeout happens we post nil to unblock the for-await
            post(name: .bodyEvaluation, object: nil)
        }

        for await bodyEvaluation in notifications(named: .bodyEvaluation).map({ $0.object as? BodyEvaluation }) {
            timeoutTask.cancel()
            guard let view = bodyEvaluation?.view else {
                // Make sure you added postBodyEvaluation() in the body of the view
                throw ViewHostingError.bodyEvaluationTimeout
            }
            guard let view = view as? T else {
                throw ViewHostingError.bodyEvaluationTypeMismatch
            }
            return view
        }
        fatalError()
    }
}
