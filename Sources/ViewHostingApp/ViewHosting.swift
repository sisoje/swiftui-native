import SwiftUI

enum ViewHosting {
    typealias ViewHostingType = (any View) -> Void
    @MainActor static var host: ViewHostingType!
}
