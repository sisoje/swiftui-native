import SwiftUI
import ViewHosting

extension EnvironmentValues {
    @Entry var loadTextService: () async -> String = {  "" }
}

struct TestView: View {
    @Environment(\.onBody) private var onBody
    @Environment(\.loadTextService) private var loadTextService
    @State private(set) var text = ""
    func loadText() async {
        text = await loadTextService()
    }
    var body: some View {
        let _ = onBody(self)
        Text(text)
            .onAppear {
                text = "onAppear"
            }
            .task {
                text = "task"
            }
    }
}
