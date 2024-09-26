import SwiftUI

struct DynamicPropertyView<Property: DynamicProperty>: View {
    let property: Property
    let onBody: (Property) -> Void

    var body: some View {
        let _ = onBody(property)
    }
}
