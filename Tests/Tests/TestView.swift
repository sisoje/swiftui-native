import SwiftUI

extension EnvironmentValues {
    @Entry var loadTextService: () async -> String = {
        fatalError("inject custom service")
    }
}

struct TestView: View {
    @Environment(\.loadTextService) var loadTextService
    @State var text = ""
    func loadText() async {
        text = await loadTextService()
    }

    var body: some View {
        fatalError("should not evaluate")
    }
}
