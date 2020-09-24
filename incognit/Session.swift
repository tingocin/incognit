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
    
    func update(_ current: (Page) -> Void) {
        page.map {
            current($0)
            balam.update($0)
        }
    }
    
    func refresh( _ id: UUID) {
        let page = pages.first { $0.id == id }!
        page.date = .init()
        balam.update(page)
    }
}
