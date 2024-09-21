import SwiftUI
@testable import ViewHosting

extension View {
    func onBody<T: View>(callback: @escaping (T) -> Void) -> some View {
        environment(\.onBody, OnBody { anyView in
            if let view = anyView as? T {
                callback(view)
            }
        })
    }
}
