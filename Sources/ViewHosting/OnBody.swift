import SwiftUI

struct CallbackKey: Hashable {
    private let reflectedType: String
    static func key<T: View>(_ t: T.Type) -> Self {
        CallbackKey(reflectedType: String(reflecting: T.self))
    }
}

typealias CallbackMap = [CallbackKey: (any View) -> Void]

extension CallbackMap {
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
    @Entry var callbackMap: CallbackMap = [:]
}

@propertyWrapper public struct OnBody<T: View>: DynamicProperty {
    @Environment(\.callbackMap) private var callbackMap
    public init() {}
    public var wrappedValue: (T) -> Void { callbackMap[] }
}
