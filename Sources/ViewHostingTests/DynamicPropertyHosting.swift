import SwiftUI

struct DynamicPropertyView<D: DynamicProperty>: View {
    let property: D
    let onBody: (Self) -> Void
    var body: some View {
        let _ = onBody(self)
    }
}

@MainActor extension DynamicProperty {
    func hosted() async -> Self {
        await withCheckedContinuation { continuation in
            DynamicPropertyView(property: self) { view in
                continuation.resume(with: .success(view))
            }.host()
        }.property
    }
}
