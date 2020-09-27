import Foundation
import Combine

struct Session {
    var page: Page?
    var user: User?
    var forwards = false
    var backwards = false
    var progress = Double()
    var pages = Set<Page>()
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let redirect = PassthroughSubject<Void, Never>()
    let dispatch = DispatchQueue(label: "", qos: .utility)

    
    
    
    
    
    mutating func add(_ page: Page) {
        pages.insert(page)
//        balam.add(page)
    }
    
    mutating func delete(_ page: Page) {
        pages.remove(page)
//        balam.remove(page)
    }
    
    mutating func forget() {
        pages = []
//        balam.remove(Page.self) { _ in true }
    }

    mutating func change(_ engine: Engine) {
//        self.engine = engine
//        balam.remove(engine)
//        balam.add(engine)
    }
}
