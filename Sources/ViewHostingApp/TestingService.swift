import SwiftUI

struct TestingService: Sendable {
    nonisolated(unsafe) var dic: [String: @MainActor (any View) -> Void] = [:]
}

extension TestingService {
    init<T: View>(for: T.Type = T.self, _ c: @escaping @MainActor (T) -> Void) {
        setCallback(c)
    }

    mutating func setCallback<T: View>(for: T.Type = T.self, _ c: @escaping @MainActor (T) -> Void) {
        dic[String(reflecting: T.self)] = { c($0 as! T) }
    }

    func getCallbeack<T: View>(for: T.Type = T.self) -> @MainActor (T) -> Void {
        dic[String(reflecting: T.self)] ?? { _ in }
    }
}

extension EnvironmentValues {
    @Entry var testingService = TestingService()
}

@propertyWrapper public struct OnBody<T: View>: DynamicProperty {
    @Environment(\.testingService) private var testingService
    public init() {}
    public var wrappedValue: @MainActor (T) -> Void { testingService.getCallbeack(for: T.self) }
}
