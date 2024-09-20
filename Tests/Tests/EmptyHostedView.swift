import SwiftUI
import ViewHosting

struct EmptyHostedView: View {
    @OnBody<Self> private var onBody
    var body: some View {
        let _ = onBody(self)
    }
}
