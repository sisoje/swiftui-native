import SwiftUI
import ViewHosting

struct TestView: View {
    @Environment(\.onBody) private var onBody
    @State var text = ""

    func loadText() async {
        text = "loaded"
    }

    var body: some View {
        let _ = onBody(self)
    }
}
