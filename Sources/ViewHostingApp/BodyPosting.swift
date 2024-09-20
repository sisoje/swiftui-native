import SwiftUI

extension Notification.Name {
    static let bodyPosting = Notification.Name("com.ViewHosting.BodyPosting")
}

struct BodyPosting<T: View>: @unchecked Sendable {
    var view: T?
}
