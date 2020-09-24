import Foundation
import Combine

struct Session {
    var current: UUID?
    var pages = Set<Page>()
    let navigate = PassthroughSubject<URL, Never>()
    
    var page: Page? {
        pages.first { $0.id == current }
    }
}
