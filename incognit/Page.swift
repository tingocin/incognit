import Foundation

final class Page: Codable, Identifiable, Hashable {
    var url: URL?
    var date: Date
    var title: String
    let id: UUID
    
    init() {
        id = .init()
        date = .init()
        title = ""
    }
    
    func hash(into: inout Hasher) {
        into.combine(id)
    }
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.id == rhs.id
    }
}
