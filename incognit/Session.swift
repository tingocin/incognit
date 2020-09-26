import Foundation
import Combine
import Balam

struct Session {
    var current: Page?
    var engine = Engine.ecosia
    var forwards = false
    var backwards = false
    var pages = Set<Page>()
    var progress = Double()
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let redirect = PassthroughSubject<Void, Never>()
    let balam = Balam("incognit")
    
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
}
