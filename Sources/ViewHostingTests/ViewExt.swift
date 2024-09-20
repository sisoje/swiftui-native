import SwiftUI
@testable import ViewHostingApp

struct TestingModifier<T: View>: ViewModifier {
    @Environment(\.testingService) private var testingService
    let callback: @MainActor (T) -> Void

    func body(content: Content) -> some View {
        content.environment(\.testingService, {
            var ns = testingService
            ns.setCallback(callback)
            return ns
        }())
    }
}

extension View {
    func onBodyCallback<T: View>(_ callback: @escaping @MainActor (T) -> Void) -> some View {
        modifier(TestingModifier(callback: callback))
    }

    func host() {
        _ = _PreviewHost.makeHost(content: self).previews
    }
}
