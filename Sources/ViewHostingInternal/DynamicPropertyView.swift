import SwiftUI
import ViewHosting

struct DynamicPropertyView<Property: DynamicProperty>: View {
    @Environment(\.onBody) private var onBody
    let property: Property
    var body: some View {
        let _ = onBody(self)
    }
}
