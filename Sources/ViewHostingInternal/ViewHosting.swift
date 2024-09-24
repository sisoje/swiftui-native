import SwiftUI

extension View {
    func imageRenderer() -> ImageRenderer<Self> {
        ImageRenderer(content: self)
    }
    
    func hosted() throws -> Self {
        try hosted(Self.self)
    }
    
    func hosted<T: View>(_ t: T.Type) throws -> T {
        try HostedContent<T> { self }.hosted()
    }
}
