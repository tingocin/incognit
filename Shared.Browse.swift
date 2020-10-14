import WidgetKit

extension Shared {
    static func browse(_ pages: Set<Page>) {
        (try? JSONEncoder().encode(pages.sorted { $0.date > $1.date }.prefix(5).map {
            Item(open: URL(string: "incognit-id://" + $0.id.uuidString), url: $0.url, title: $0.title)
        })).map {
            history = $0
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
