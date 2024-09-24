import SwiftUI
@testable import ViewHostingInternal
import XCTest

@MainActor final class Tests: XCTestCase {
    func testHostedViewChanges() async throws {
        let content = HostedContent<TestView> {
            TestView()
                .environment(\.loadTextService) { "loaded" }
        }
        let view = try content.hosted()
        XCTAssertEqual(view.text, "onAppear")
        try await content.onBody()
        XCTAssertEqual(view.text, "task")
        await view.loadText()
        try await content.onBody()
        XCTAssertEqual(view.text, "loaded")
    }

    func testHostedView() throws {
        let view = try TestView().hosted()
        XCTAssertEqual(view.text, "onAppear")
    }

    func testHostedDynamicProperty() throws {
        let state = try State(initialValue: 0).hosted()
        XCTAssertEqual(state.wrappedValue, 0)
        state.wrappedValue += 1
        XCTAssertEqual(state.wrappedValue, 1)
    }

    func testHostedViewPerformance() {
        measure {
            do {
                _ = try TestView().hosted()
            }
            catch {
                XCTFail()
            }
        }
    }

    func testHostedDynamicPropertyPerformance() {
        measure {
            do {
                _ = try State(wrappedValue: 0).hosted()
            }
            catch {
                XCTFail()
            }
        }
    }
}
