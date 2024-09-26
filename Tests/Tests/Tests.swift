import SwiftUI
import ViewHosting
import XCTest

extension TestView: DynamicProperty {}

@MainActor final class Tests: XCTestCase {
    func testHostedView() async throws {
        let injectedText = UUID().uuidString
        let hosted = try TestView().hosted { view in
            view.environment(\.loadTextService) {
                injectedText
            }
        }
        await hosted.loadText()
        XCTAssertEqual(hosted.text, injectedText)
    }

    func testHostedState() throws {
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

    func testHostedStatePerformance() {
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
