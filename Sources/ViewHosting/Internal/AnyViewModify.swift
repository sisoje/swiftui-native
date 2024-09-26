import SwiftUI

extension View {
    func anyViewModify(_ modify: (any View) -> any View) -> some View {
        modify(self)
    }
}
