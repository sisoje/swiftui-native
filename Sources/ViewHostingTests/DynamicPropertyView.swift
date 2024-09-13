import SwiftUI

public extension View where Self: DynamicProperty {
    var body: some View {
        let _ = postBodyEvaluation()
        return Color.clear
    }
}
