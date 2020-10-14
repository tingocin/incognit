import WidgetKit

extension Shared {
    struct Timeline: TimelineEntry {
        static var latest: Self {
            .init(items: Shared.get(.history).flatMap { $0 as? Data }.flatMap { try? JSONDecoder().decode([Item].self, from: $0) } ?? [])
        }
        
        static let empty = Self(items: [])
        static let placerholder = Self(items: [
                                        .init(open: nil, url: nil, title: "incognit incognit incognit incognit incognit incognit"),
                                        .init(open: nil, url: nil, title: "incognit incognit"),
                                        .init(open: nil, url: nil, title: "incognit incognit incognit incognit"),
                                        .init(open: nil, url: nil, title: "incognit incognit incognit"),
                                        .init(open: nil, url: nil, title: "incognit incognit incognit incognit incognit")])
        
        let items: [Item]
        let date = Date()
    }
}
