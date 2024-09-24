import Combine
import SwiftUI

struct HostedContent<T: View> {
    private let currentValue = CurrentValueSubject<T?, Never>(nil)
    private let hostView: () -> Void
}

@MainActor extension HostedContent {
    init(content: () -> some View) {
        let renderer = content().onBody(type: T.self) { [currentValue] in
            currentValue.send($0)
        }
        .frame(width: 0, height: 0)
        .imageRenderer()
        hostView = { _ = renderer.cgImage }
    }

    func hosted() throws -> T {
        hostView()
        guard let view = currentValue.value else {
            throw ViewHostingError.missing
        }
        return view
    }

    func onBody(timeout: TimeInterval = 1) async throws {
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            currentValue.send(nil)
        }
        for await isTimeout in currentValue
            .dropFirst()
            .map({ $0 == nil })
            .receive(on: DispatchQueue.main)
            .values
        {
            if isTimeout {
                break
            }
            timeoutTask.cancel()
            return
        }
        throw ViewHostingError.timeout
    }
}
