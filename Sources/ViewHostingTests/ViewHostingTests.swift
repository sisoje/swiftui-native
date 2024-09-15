import SwiftUI
@testable import ViewHostingApp
import XCTest

protocol TestView: BodyPostingView {}

extension TestView {
    var body: some View {
        let _ = bodyPost()
        return Color.clear
    }
}

final class ViewHostingTests: XCTestCase {
    struct EmptyHostedView1: TestView {}
    struct EmptyHostedView2: TestView {}
    @propertyWrapper struct DummyWrapper: DynamicProperty {
        @State var wrappedValue = 0
    }
}

@MainActor extension ViewHostingTests {
    @available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
    func testNavigation() async throws {
        struct One: BodyPostingView {
            @State var numbers: [Int] = []
            var body: some View {
                let _ = bodyPost()
                NavigationStack(path: $numbers) {
                    ProgressView()
                        .navigationDestination(
                            for: Int.self,
                            destination: { _ in EmptyHostedView1() }
                        )
                }
            }
        }

        let one = try await One().hosted()
        one.numbers.append(1)
        try await EmptyHostedView1.onBodyPosting()
    }

    func testOnAppear() async throws {
        struct AppearingView: BodyPostingView {
            @State var number = 0
            var body: some View {
                let _ = bodyPost()
                Text(number.description)
                    .onAppear { number += 1 }
            }
        }

        let view = try await AppearingView().hosted()
        XCTAssertEqual(view.number, 1)
    }

    func testTask() async throws {
        struct TaskView: BodyPostingView {
            @State var number = 0
            var body: some View {
                let _ = bodyPost()
                Text(number.description)
                    .task { number += 1 }
            }
        }

        let view = try await TaskView().hosted()
        XCTAssertEqual(view.number, 0)
        try await TaskView.onBodyPosting()
        XCTAssertEqual(view.number, 1)
    }

    func testHostedView() async throws {
        _ = try await EmptyHostedView1().hosted()
    }

    func testDynamicProperty() async throws {
        let hosted1 = await DummyWrapper().hosted()
        let hosted2 = await DummyWrapper().hosted()
        _ = try await EmptyHostedView1().hosted()
        for hosted in [hosted1, hosted2] {
            XCTAssertEqual(hosted.wrappedValue, 0)
            hosted.wrappedValue += 1
            XCTAssertEqual(hosted.wrappedValue, 1)
        }
    }

    func testPerformanceOfHosted() {
        measure {
            let expectation = expectation(description: UUID().uuidString)
            Task {
                _ = try! await EmptyHostedView1().hosted()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)
        }
    }

    func testPerformanceOfDynamicProperty() {
        measure {
            let expectation = expectation(description: UUID().uuidString)
            Task {
                _ = await DummyWrapper().hosted()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)
        }
    }
}
