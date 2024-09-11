@preconcurrency import SwiftUI

extension Notification.Name {
    static let bodyEvaluation = Notification.Name("com.ViewHosting.bodyEvaluation")
}

struct BodyEvaluation: Sendable {
    let view: any View
}

public extension View {
    func postBodyEvaluation() {
        assert({
            Self._printChanges()
            NotificationCenter.default.post(name: .bodyEvaluation, object: BodyEvaluation(view: self))
        }() == ())
    }
}
