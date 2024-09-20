import SwiftUI
import ViewHosting

struct AsyncTextView: View {
    @OnBody<Self> var onBody
    @State var text = ""
    func load() async {
        await MainActor.run {
            text = "loaded"
        }
    }
    var body: some View {
        let _ = onBody(self)
    }
}
