import SwiftUI
@testable import ViewHosting

extension View {
    func onBody<T: View>(callback: @escaping (T) -> Void) -> some View {
        environment(\.onBody, { view in
            if let view = view as? T {
                callback(view)
            }
        })
    }
}
