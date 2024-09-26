import SwiftUI

// In your test target you conform your View to DynamicProperty: `extension TestView: DynamicProperty {}`
// That makes hosting available: `let view = try TestView().hosted()`
// You inject dependencies using modification closure
@MainActor public extension DynamicProperty {
    func hosted(modification: (any View) -> any View = { $0 }) throws -> Self {
        var hostedProperty: Self?
        
        DynamicPropertyView(property: self) {
            hostedProperty = $0
        }
        .anyViewModify(modification)
        .host()
        
        guard let hostedProperty else {
            throw HostingError.missing
        }
        
        return hostedProperty
    }
}
