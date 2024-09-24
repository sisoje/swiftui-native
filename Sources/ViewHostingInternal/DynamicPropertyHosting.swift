import SwiftUI
import ViewHosting

private struct DynamicPropertyView<Property: DynamicProperty>: View {
    @Environment(\.onBody) private var onBody
    let property: Property
    var body: some View {
        let _ = onBody(self)
    }
}

@MainActor extension DynamicProperty {
    func hosted() throws -> Self {
        try DynamicPropertyView(property: self).hosted().property
    }
}
