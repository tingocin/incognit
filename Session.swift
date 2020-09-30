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
    
    var user: User?
    var error: String?
    var forwards = false
    var backwards = false
    var progress = Double()
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let save = PassthroughSubject<Page?, Never>()
    let pages = CurrentValueSubject<Set<Page>, Never>([])
    let dispatch = DispatchQueue(label: "", qos: .utility)
    private var subs = Set<AnyCancellable>()

    init() {
        save.debounce(for: .seconds(1), scheduler: dispatch).sink {
            $0.map(FileManager.default.save)
        }.store(in: &subs)
        
        save.combineLatest(pages).debounce(for: .seconds(3), scheduler: dispatch).sink {
            (try? JSONEncoder().encode($0.1.sorted { $0.date > $1.date }.prefix(3).map {
                History.Item(open: URL(string: "incognit-id://" + $0.id.uuidString)!, url: $0.url, title: $0.title)
            })).map {
                History.defaults.setValue($0, forKey: History.key)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }.store(in: &subs)
    }
    
    mutating func browse(_ string: String) {
        guard let url = string.url(user!.engine) else { return }
        browse(url)
    }
    
    mutating func browse(_ url: URL) {
        if page == nil {
            let page = Page(url: url)
            self.page = page
            pages.value.insert(page)
            save.send(page)
        } else {
            navigate.send(url)
        }
    }
    
    mutating func delete(_ page: Page) {
        pages.value.remove(page)
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
    
    func save(_ user: User) {
        dispatch.async {
            FileManager.default.save(user)
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
            $0.count > 1 && $0.last!.count > 1 && $0.first!.count > 2
        } (components(separatedBy: "."))
    }
}
