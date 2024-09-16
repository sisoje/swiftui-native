import SwiftUI

enum ViewHosting {
    typealias ViewHostingType = (any View) -> Void
    @MainActor static var host: ViewHostingType! = windowHosting
}

#if canImport(UIKit) && !os(watchOS)
    extension ViewHosting {
        @MainActor private static var window: UIWindow!

        @MainActor static var windowHosting: ViewHostingType = { view in
            window = window ?? UIWindow()
            window.rootViewController = UIHostingController(rootView: AnyView(view))
            window.makeKeyAndVisible()
        }
    }
#else
    extension ViewHosting {
        @MainActor static var windowHosting: ViewHostingType?
    }
#endif
