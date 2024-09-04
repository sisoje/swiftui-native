import SwiftUI
import XCTest

final class ViewHostingTests: XCTestCase {}

@MainActor extension ViewHostingTests {
    struct MinimalView: View {
        var body: some View {
            let _ = postBodyEvaluation()
            ProgressView()
        }
    }
    
    @available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
    func testNavigation() async throws {
        struct One: View {
            @State var numbers: [Int] = []
            var body: some View {
                let _ = postBodyEvaluation()
                NavigationStack(path: $numbers) {
                    ProgressView()
                        .navigationDestination(
                            for: Int.self,
                            destination: Two.init
                        )
                }
            }
        }
            
        struct Two: View {
            let number: Int
            var body: some View {
                let _ = postBodyEvaluation()
                Text(number.description)
            }
        }
        
        let one = try await One.host { One() }
        one.numbers.append(1)
        try await Two.onUpdate()
    }
    
    func testOnAppear() async throws {
        struct AppearingView: View {
            @State var number = 0
            var body: some View {
                let _ = postBodyEvaluation()
                Text(number.description)
                    .onAppear { number += 1 }
            }
        }
        
        let view = try await AppearingView.host { AppearingView() }
        XCTAssertEqual(view.number, 1)
    }
    
    func testTask() async throws {
        struct TaskView: View {
            @State var number = 0
            var body: some View {
                let _ = postBodyEvaluation()
                Text(number.description)
                    .task { number += 1 }
            }
        }
        
        let view = try await TaskView.host { TaskView() }
        XCTAssertEqual(view.number, 0)
        try await TaskView.onUpdate()
        XCTAssertEqual(view.number, 1)
    }
    
    func testHostedView() async throws {
        _ = try await MinimalView.host { MinimalView() }
    }
    
    func testWrongView() async throws {
        do {
            _ = try await Text.host { MinimalView() }
            XCTFail("we expected this to fail")
        }
        catch ViewHostingError.bodyEvaluationTypeMismatch {}
        catch { throw error }
    }
}
