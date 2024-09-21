import SwiftUI
@testable import ViewHostingTesting
import XCTest

@MainActor final class ViewHostingTests: XCTestCase {
    func testAsyncText() async throws {
        let view = try await ViewHosting.hosted { TestView() }
        XCTAssertEqual(view.text, "")
        await view.loadText()
        XCTAssertEqual(view.text, "loaded")
    }
    
    func testHostedView() async throws {
        _ = try await ViewHosting.hosted { TestView() }
    }

    func testHostedDynamicProperty() async throws {
        let hosted = try await State(initialValue: 0).hosted()
        XCTAssertEqual(hosted.wrappedValue, 0)
        hosted.wrappedValue += 1
        XCTAssertEqual(hosted.wrappedValue, 1)
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
