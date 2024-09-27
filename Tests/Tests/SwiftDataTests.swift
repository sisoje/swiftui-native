import SwiftData
import SwiftUI
import XCTest

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
@MainActor final class SwiftDataTests: XCTestCase {
    var context: ModelContainer!
    
    override func setUp() async throws {
        context = try Self.makeContainer()
    }
    
    static func makeContainer() throws -> ModelContainer {
        let schema = Schema([TodoItem.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    struct SwiftDataView: View, DynamicProperty {
        @Query var items: [TodoItem]
        @Environment(\.modelContext) var context

        func add(_ title: String) throws {
            let newTodo = TodoItem(title: title)
            context.insert(newTodo)
            try context.save()
        }
        
        let body = EmptyView()
    }
    
    @Model class TodoItem {
        @Attribute(.unique) var id: UUID
        var title: String

        init(title: String) {
            self.id = UUID()
            self.title = title
        }
    }
    
    func testSwiftData() throws {
        let hostedData = try SwiftDataView().hosted { view in
            view.modelContainer(context)
        }
        XCTAssertEqual(hostedData.items.count, 0)
        let newTitle = UUID().uuidString
        try hostedData.add(newTitle)
        XCTAssertEqual(hostedData.items.count, 1)
        XCTAssertEqual(hostedData.items[0].title, newTitle)
    }
}
