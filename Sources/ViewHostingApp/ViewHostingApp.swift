import SwiftUI

public struct ViewHostingApp: App {
    public init() {}
    @State private var view: any View = EmptyView()
    public var body: some Scene {
        let _ = ViewHosting.host = { view = $0 }
        WindowGroup {
            AnyView(view)
        }
    }
}
