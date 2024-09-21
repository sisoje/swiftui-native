import SwiftUI
@testable import ViewHostingInternal
import XCTest

@MainActor final class Tests: XCTestCase {
    func testHostedView() async throws {
        let view = try await ViewHosting.hosted { TestView() }
        XCTAssertEqual(view.text, "")
        await view.loadText()
        XCTAssertEqual(view.text, "loaded")
    }

    func testHostedDynamicProperty() async throws {
        let state = try await State(initialValue: 0).hosted()
        XCTAssertEqual(state.wrappedValue, 0)
        state.wrappedValue += 1
        XCTAssertEqual(state.wrappedValue, 1)
    }

    func testHostedViewPerformance() {
        measure {
            let expectation = expectation(description: UUID().uuidString)
            Task {
                do {
                    _ = try await ViewHosting.hosted { TestView() }
                } catch {
                    XCTFail()
                }
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)
        }
    }

    func testHostedDynamicPropertyPerformance() {
        measure {
            let expectation = expectation(description: UUID().uuidString)
            Task {
                do {
                    _ = try await State(wrappedValue: 1).hosted()
                } catch {
                    XCTFail()
                }
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)
        }
    }
}
