@preconcurrency import SwiftUI

extension Notification.Name {
    static let bodyPosting = Notification.Name("com.ViewHosting.BodyPosting")
}

struct BodyPosting<T: BodyPostingView>: @unchecked Sendable {
    var view: T?
}
