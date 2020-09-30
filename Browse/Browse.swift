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
                        .font(Font.headline.bold())
                        .foregroundColor(Color(.systemIndigo))
                }
                .frame(height: 40)
                .padding()
                LL(items: entry.items)
            }.background(Color(.secondarySystemBackground))
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}

private struct LL: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let items: [History.Item]
    
    var body: some View {
        VStack {
            if items.isEmpty {
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.init(.quaternaryLabel))
                    .padding()
            } else {
                if family != .systemLarge {
                    Item(item: items.first!)
                } else {
                    ForEach(0 ..< items.count) {
                        Item(item: items[$0])
                    }
                }
            }
            Spacer()
        }
    }
}

private struct Item: View {
    let item: History.Item
    
    var body: some View {
        Link(destination: item.open) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.init(.tertiarySystemBackground))
                HStack {
                    VStack {
                        HStack {
                            Text(verbatim: item.title)
                                .font(.footnote)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        HStack {
                            Text(verbatim: item.url.absoluteString)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }.padding()
            }
            .frame(height: 40)
            .padding()
        }
    }
}

private struct Provider: TimelineProvider {
    func placeholder(in: Context) -> History {
        .empty
    }

    func getSnapshot(in context: Context, completion: @escaping (History) -> ()) {
        completion(context.isPreview ? .empty : .latest)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [.latest], policy: .never))
    }
}
