import SwiftUI

public protocol BodyPostingView: View {
    func bodyPost()
}

public extension BodyPostingView {
    func bodyPost() {
        assert({
            Self._printChanges()
            NotificationCenter.default.post(name: .bodyPosting, object: BodyPosting(view: self))
        }() == ())
    }
}
