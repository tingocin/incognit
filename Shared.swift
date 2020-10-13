import WidgetKit

struct Shared: TimelineEntry {
    static var latest: Self {
        .init(items: defaults.data(forKey: Key.history.rawValue).flatMap { try? JSONDecoder().decode([Item].self, from: $0) } ?? [])
    }
    
    static let empty = Self(items: [])
    static let placerholder = Self(items: [
                                    .init(open: nil, url: nil, title: "incognit incognit incognit incognit incognit incognit"),
                                    .init(open: nil, url: nil, title: "incognit incognit"),
                                    .init(open: nil, url: nil, title: "incognit incognit incognit incognit"),
                                    .init(open: nil, url: nil, title: "incognit incognit incognit"),
                                    .init(open: nil, url: nil, title: "incognit incognit incognit incognit incognit")])
    private static let defaults = UserDefaults(suiteName: "group.incognit.share")!
    
    static func set(_ value: Any?, key: Key) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    static func get(_ key: Key) -> Any? {
        defaults.object(forKey: key.rawValue)
    }
    
    let items: [Item]
    let date = Date()
}
