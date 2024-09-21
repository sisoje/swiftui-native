import SwiftUI
@testable import ViewHosting

extension View {
    func onBody<T: View>(type: T.Type, callback: @escaping (T) -> Void) -> some View {
        environment(\.onBody) {
            if let view = $0 as? T {
                callback(view)
            }
        }
    }
}
