import SwiftUI

@MainActor extension DynamicProperty {
    func hosted() async throws -> Self {
        try await ViewHosting.hosted { DynamicPropertyView(property: self) }.property
    }
}
