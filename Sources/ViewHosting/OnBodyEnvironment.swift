import SwiftUI

public extension EnvironmentValues {
    @Entry var onBody: (any View) -> Void = { _ in }
}
