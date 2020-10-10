import Foundation
import Combine
import WidgetKit

struct Session {
    weak var page: Page? {
        didSet {
            forwards = false
            backwards = false
            progress = 0
        }
    }
    
    var error: String?
    var forwards = false
    var backwards = false
    var typing = false
    var progress = Double()
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let type = PassthroughSubject<Void, Never>()
    let resign = PassthroughSubject<Void, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    let print = PassthroughSubject<Void, Never>()
    let pdf = PassthroughSubject<Void, Never>()
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
            (try? JSONEncoder().encode(pages.sorted { $0.date > $1.date }.prefix(5).map {
                History.Item(open: URL(string: "incognit-id://" + $0.id.uuidString), url: $0.url, title: $0.title)
            })).map {
                History.defaults.setValue($0, forKey: History.key)
                WidgetCenter.shared.reloadAllTimelines()
            }
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
    
    mutating func browse(_ string: String) {
        guard let url = string.url(User.engine) else { return }
        browse(url)
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
        pages.value = []
        save.send(nil)
        dispatch.async {
            FileManager.default.forget()
        }
    }
}

private extension String {
    func url(_ engine: Engine) -> URL? {
        {
            $0.isEmpty ? nil : URL(string: $0.content(engine))
        } (trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private func content(_ engine: Engine) -> Self {
        fullURL ? self : semiURL ? "http://" + self : engine.prefix + (addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    private var fullURL: Bool {
        (contains("http://") || contains("https://")) && semiURL
    }
    
    private var semiURL: Bool {
        {
            $0.count > 1 && $0.last!.count > 1 && $0.first!.count > 1
        } (components(separatedBy: "."))
    }
}
