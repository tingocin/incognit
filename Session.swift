import Foundation
import Combine

struct Session {
    weak var page: Page? {
        didSet {
            state = .init()
        }
    }
    
    var typing = false
    var state = State()
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let resign = PassthroughSubject<Void, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    let print = PassthroughSubject<Void, Never>()
    let pdf = PassthroughSubject<Void, Never>()
    let type = PassthroughSubject<String?, Never>()
    let find = PassthroughSubject<String, Never>()
    let save = PassthroughSubject<Page?, Never>()
    let pages = CurrentValueSubject<Set<Page>?, Never>(nil)
    let dispatch = DispatchQueue(label: "", qos: .utility)
    private var subs = Set<AnyCancellable>()

    init() {
        save.debounce(for: .seconds(1), scheduler: dispatch).sink {
            $0.map(FileManager.default.save)
        }.store(in: &subs)
        
        save.combineLatest(pages).debounce(for: .seconds(2), scheduler: dispatch).sink {
            guard let pages = $0.1 else { return }
            Shared.browse(pages)
            Shared.chart(pages)
        }.store(in: &subs)
    }
    
    mutating func browse(id: String) {
        (pages.value?.first { $0.id.uuidString == id } ?? FileManager.default.load(id)).map { item in
            item.date = .init()
            if page == nil {
                page = item
            } else {
                page = item
                navigate.send(item.url)
            }
            save.send(item)
        }
    }
    
    mutating func browse(_ url: URL) {
        if page == nil {
            let page = Page(url: url)
            self.page = page
            pages.value?.insert(page)
            save.send(page)
        } else {
            navigate.send(url)
        }
    }
    
    mutating func delete(_ page: Page) {
        pages.value?.remove(page)
        save.send(nil)
        dispatch.async {
            FileManager.default.delete(page)
        }
    }
    
    mutating func forget() {
        page = nil
        pages.value = []
        save.send(nil)
        dispatch.async {
            FileManager.default.forget()
        }
    }
}
