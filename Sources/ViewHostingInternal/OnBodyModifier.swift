import SwiftUI

extension View {
    func onBody<T: View>(type: T.Type, callback: @escaping (T) -> Void) -> some View {
        environment(\.onBody) { view in
            if let view = view as? T {
                callback(view)
            }
        }
    }
}
