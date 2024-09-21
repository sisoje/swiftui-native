import SwiftUI

public struct OnBody: @unchecked Sendable {
    var callback: (any View) -> Void = { _ in }
}

public extension OnBody {
    func callAsFunction(_ view: any View) {
        callback(view)
    }
}

public extension EnvironmentValues {
    @Entry var onBody = OnBody()
}
