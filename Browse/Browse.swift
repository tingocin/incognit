import WidgetKit
import SwiftUI

@main struct Browse: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Browse", provider: Provider()) { entry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.init(.secondarySystemBackground))
                    Image(systemName: "magnifyingglass")
                        .font(Font.headline.bold())
                        .foregroundColor(Color(.systemIndigo))
                }
                .frame(height: 40)
                .padding()
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

    func getSnapshot(in context: Context, completion: @escaping (Model) -> ()) {
        completion(context.isPreview ? .empty : .init(pages: 0))
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [.init(pages: 0)], policy: .never))
    }
}

private struct Model: TimelineEntry {
    static let empty = Self(pages: 0)
    let pages: Int
    let date = Date()
}
