import SwiftUI
@testable import ViewHostingApp

struct DynamicPropertyView<D: DynamicProperty>: View {
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
        let eval = await withCheckedContinuation { cont in
            DynamicPropertyView(property: self) {
                cont.resume(with: .success(BodyEvaluation(view: $0)))
            }
            .host()
        }
        return (eval.view as! DynamicPropertyView<Self>).property
    }
}
