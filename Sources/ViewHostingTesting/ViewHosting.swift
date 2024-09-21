import Combine
import SwiftUI

struct ViewHosting<T: View> {
    private let currentValue = CurrentValueSubject<SendableView?, Never>(nil)
}

private extension ViewHosting {
    struct SendableView: @unchecked Sendable { let view: T }

    enum ViewHostingError: Error {
        case timeout
        case missing
    }

    static func host(content: () -> any View) {
        _ = _PreviewHost.makeHost(content: content()).previews
    }
}

@MainActor extension ViewHosting {
    static func hosted(content: () -> T) async throws -> T {
        try await ViewHosting().hosted(content: content)
    }

    func hosted(content: () -> any View) async throws -> T {
        Self.host {
            content().onBody {
                currentValue.send(SendableView(view: $0))
            }
        }
        guard let view = currentValue.value?.view else {
            throw ViewHostingError.missing
        }
        return view
    }

    @discardableResult func onBody(timeout: TimeInterval = 1) async throws -> T {
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
        throw ViewHostingError.timeout
    }
}
