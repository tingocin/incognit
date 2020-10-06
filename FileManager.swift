import Foundation

extension FileManager {
    var pages: Set<Page> {
        guard fileExists(atPath: Self._pages.path) else { return [] }
        return .init((try? contentsOfDirectory(at: Self._pages, includingPropertiesForKeys: [], options: .skipsHiddenFiles)).map {
            $0.compactMap {
                try? JSONDecoder().decode(Page.self, from: Data(contentsOf: $0))
            }
        } ?? [])
    }
    
    func load(_ id: String) -> Page? {
        try? JSONDecoder().decode(Page.self, from: Data(contentsOf: Self._pages.appendingPathComponent(id)))
    }
    
    func save(_ page: Page) {
        var url = Self._pages
        if !fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? createDirectory(at: url, withIntermediateDirectories: true)
        }
        try? JSONEncoder().encode(page).write(to: url.appendingPathComponent(page.id.uuidString), options: .atomic)
    }
    
    func delete(_ page: Page) {
        try? removeItem(at: Self._pages.appendingPathComponent(page.id.uuidString))
    }
    
    func forget() {
        try? removeItem(at: Self._pages)
    }
    
    private static let root = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private static let _pages = root.appendingPathComponent("pages")
}
