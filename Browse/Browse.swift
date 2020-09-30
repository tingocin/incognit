import WidgetKit
import SwiftUI

@main struct Browse: Widget {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Browse", provider: Provider()) { entry in
            ZStack {
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.init(.quaternaryLabel))
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: -2, y: -2)
                            .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: 2, y: 2)
                            .foregroundColor(.init(.secondarySystemBackground))
                        Image(systemName: "magnifyingglass")
                            .font(Font.headline.bold())
                            .foregroundColor(Color(.systemIndigo))
                    }
                    .frame(height: 40)
                    .padding()
                    if family == .systemLarge {
                        Spacer()
                    } else {
                        Spacer()
                    }
                }
            }.background(Color(.secondarySystemBackground))
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}

private struct Provider: TimelineProvider {
    func placeholder(in: Context) -> History {
        .empty
    }

    func getSnapshot(in context: Context, completion: @escaping (History) -> ()) {
        completion(context.isPreview ? .empty : .init(items: []))
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [.init(items: [])], policy: .never))
    }
}
