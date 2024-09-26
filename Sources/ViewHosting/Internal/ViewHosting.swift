import SwiftUI

extension View {
    func host() {
        _ = ImageRenderer(content: self).cgImage
    }
}
