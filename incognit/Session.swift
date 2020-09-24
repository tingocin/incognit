import Foundation

struct Session {
    var current: UUID?
    var pages = Set<Page>()
    
    var page: Page? {
        pages.first { $0.id == current }
    }
}
