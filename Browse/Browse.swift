import WidgetKit
import SwiftUI

@main struct Browse: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Browse", provider: Provider()) { entry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: -2, y: -2)
                        .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: 2, y: 2)
                        .foregroundColor(.init(.secondarySystemBackground))
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }.frame(height: 40)
                Spacer()
            }
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}

private struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Model {
        .empty
    }

    func getSnapshot(in: Context, completion: @escaping (Model) -> ()) {
        completion(.empty)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [.init(pages: 0)], policy: .never))
    }
}

private struct Model: TimelineEntry {
    static let empty = Self(pages: 0)
    let pages: Int
    let date = Date()
}
