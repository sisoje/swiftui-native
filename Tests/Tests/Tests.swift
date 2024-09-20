import SwiftUI
@testable import ViewHostingTests
import XCTest

@MainActor final class ViewHostingTests: XCTestCase {
    struct EmptyHostedView: View {
        var body: some View {
            let _ = bodyPost()
            return Color.clear
        }
    }

    func testHostedView() async throws {
        _ = try await EmptyHostedView().hosted()
    }

    func testHostedDynamicProperty() async {
        let hosted = await State(initialValue: 0).hosted()
        XCTAssertEqual(hosted.wrappedValue, 0)
        hosted.wrappedValue += 1
        XCTAssertEqual(hosted.wrappedValue, 1)
    }

    func testHostedViewPerformance() {
        measure {
            let expectation = expectation(description: UUID().uuidString)
            Task {
                do {
                    _ = try await EmptyHostedView().hosted()
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
                _ = await State(wrappedValue: 1).hosted()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)
        }
    }
}
