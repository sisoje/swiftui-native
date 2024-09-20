import Combine
@preconcurrency import SwiftUI

struct BodyPosting<T: View>: @unchecked Sendable {
    let view: T
}

struct ViewHosting<T: View>: @unchecked Sendable {
    private let currentValue = CurrentValueSubject<BodyPosting<T>?, Never>(nil)
}

@MainActor extension ViewHosting {
    func hosted(content: () -> any View) async throws -> T {
        content().onBodyCallback { view in
            currentValue.send(BodyPosting(view: view))
        }.host()
        guard let view = currentValue.value?.view else {
            throw ViewHostingError.missing
        }
        return view
    }

    @discardableResult func onBodyPosting(timeout: TimeInterval = 1) async throws -> T {
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            currentValue.send(nil)
        }
        for await bodyEvaluation in currentValue.dropFirst().values {
            timeoutTask.cancel()
            guard let view = bodyEvaluation?.view else {
                throw ViewHostingError.timeout
            }
            return view
        }
        fatalError()
    }
}
