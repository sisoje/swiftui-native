import SwiftUI

struct ViewTypeKey: Hashable {
    private let reflectedType: String
    static func key<T: View>(_ t: T.Type) -> Self {
        ViewTypeKey(reflectedType: String(reflecting: T.self))
    }
}

typealias ViewBodyCallbackMap = [ViewTypeKey: (any View) -> Void]

extension ViewBodyCallbackMap {
    subscript<T: View>(_ type: T.Type = T.self) -> (T) -> Void {
        get {
            self[.key(T.self)] ?? { _ in }
        }
        set {
            self[.key(T.self)] = { anyView in newValue(anyView as! T) }
        }
    }
}

extension EnvironmentValues {
    @Entry var viewBodyCallbackMap: ViewBodyCallbackMap = [:]
}
