import Foundation
import Combine
import Balam

struct Session {
    var current: UUID?
    var pages = Set<Page>()
    let navigate = PassthroughSubject<URL, Never>()
    let balam = Balam("incognit")
    
    var page: Page? {
        pages.first { $0.id == current }
    }
    
    mutating func add(_ page: Page) {
        pages.insert(page)
        balam.add(page)
    }
    
    mutating func delete(_ page: Page) {
        pages.remove(page)
        balam.remove(page)
    }
    
    mutating func forget() {
        pages = []
        balam.remove(Page.self) { _ in true }
    }
    
    func update(_ current: (Page) -> Void) {
        page.map {
            current($0)
            balam.update($0)
        }
    }
    
    func refresh(_ page: Page) {
        page.date = .init()
        balam.update(page)
    }
}
