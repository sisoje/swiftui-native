import SwiftUI

public struct ViewHostingApp: App {
    public init() {}
    @State var view: any View = EmptyView()
    nonisolated(unsafe) static var shared: Self!
    public var body: some Scene {
        let _ = Self.shared = self
        WindowGroup {
            AnyView(view)
        }
    }
}
