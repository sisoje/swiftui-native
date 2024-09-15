import SwiftUI

struct DynamicPropertyView<D: DynamicProperty>: View, Sendable {
    let property: D
    let initialized: (Self) -> Void
    var body: some View {
        Color.clear
            .onAppear {
                initialized(self)
            }
    }
}

extension DynamicProperty {
    @MainActor func hosted() async -> Self {
        await withCheckedContinuation { cont in
            DynamicPropertyView(property: self) {
                cont.resume(with: .success($0))
            }
            .host()
        }.property
    }
}
