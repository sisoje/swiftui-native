import SwiftUI
import ViewHosting

struct DynamicPropertyView<D: DynamicProperty>: View {
    @Environment(\.onBody) private var onBody
    let property: D
    var body: some View {
        let _ = onBody(self)
    }
}
