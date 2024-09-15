import SwiftUI

public extension View {
    func bodyPost() {
        assert({
            Self._printChanges()
            NotificationCenter.default.post(name: .bodyPosting, object: BodyPosting(view: self))
        }() == ())
    }
}
