import SwiftUI
@testable import ViewHostingApp

struct DynamicPropertyView<D: DynamicProperty>: View {
    @OnBody<Self> private var onBody
    let property: D
    var body: some View {
        let _ = onBody(self)
    }
}

@MainActor extension DynamicProperty {
    func hosted() async throws -> Self {
        try await ViewHosting<DynamicPropertyView<Self>>().hosted {
            DynamicPropertyView(property: self)
        }.property
    }
}
