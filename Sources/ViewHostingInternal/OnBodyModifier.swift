import SwiftUI
@testable import ViewHosting

struct OnBodyModifier<T: View>: ViewModifier {
    @Environment(\.callbackMap) private var callbackMap
    let callback: (T) -> Void
    func body(content: Content) -> some View {
        content.environment(\.callbackMap, {
            var ns = callbackMap
            ns[] = callback
            return ns
        }())
    }
}

extension View {
    func onBody<T: View>(_ type: T.Type = T.self, _ callback: @escaping (T) -> Void) -> some View {
        modifier(OnBodyModifier(callback: callback))
    }
}
