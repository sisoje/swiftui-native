import SwiftUI
@testable import ViewHostingApp

extension ViewHosting {
    @MainActor static func prepareHosting() -> Bool {
        host = host ?? windowHosting
        return host != nil
    }
}

#if canImport(UIKit) && !os(watchOS)
    import UIKit

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
