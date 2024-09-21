import SwiftUI
@testable import ViewHosting

extension View {
    func onBody<T: View>(callback: @escaping (T) -> Void) -> some View {
        environment(\.onBody, {
            if let view = $0 as? T {
                callback(view)
            }
        })
    }
}
