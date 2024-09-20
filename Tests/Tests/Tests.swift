import SwiftUI
@testable import ViewHostingApp
@testable import ViewHostingTests
import XCTest

struct EmptyHostedView: View {
    @OnBody<Self> private var onBody
    var body: some View {
        let _ = onBody(self)
        return Color.clear
    }
}

extension EmptyHostedView {
    func hosted() async throws -> Self {
        try await ViewHosting().hosted {
            self
        }
    }
}

@MainActor final class ViewHostingTests: XCTestCase {
    func testHostedView() async throws {
        _ = try await EmptyHostedView().hosted()
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
