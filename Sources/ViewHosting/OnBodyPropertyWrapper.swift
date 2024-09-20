import SwiftUI

@propertyWrapper public struct OnBody<T: View>: DynamicProperty {
    @Environment(\.viewBodyCallbackMap) private var viewBodyCallbackMap
    public init() {}
    public var wrappedValue: (T) -> Void { viewBodyCallbackMap[] }
}
