import Foundation
import Combine
import Balam

struct Session {
    var current: UUID?
    var engine = Engine.ecosia
    var forwards = false
    var backwards = false
    var pages = Set<Page>()
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let change = PassthroughSubject<Void, Never>()
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

    mutating func change(_ engine: Engine) {
        self.engine = engine
        balam.remove(engine)
        balam.add(engine)
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
