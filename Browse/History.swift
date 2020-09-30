import WidgetKit

struct History: TimelineEntry {
    static var latest: Self {
        .init(items: defaults.data(forKey: key).flatMap { try? JSONDecoder().decode([Item].self, from: $0) } ?? [])
    }
    
    static let defaults = UserDefaults(suiteName: "group.incognit.share")!
    static let key = "history"
    static let empty = Self(items: [])
    
    let items: [Item]
    let date = Date()
}
