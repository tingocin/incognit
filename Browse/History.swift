import WidgetKit

struct History: TimelineEntry {
    static let empty = Self(items: [])
    let items: [Item]
    let date = Date()
}
