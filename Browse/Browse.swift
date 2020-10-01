import WidgetKit
import SwiftUI

@main struct Browse: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Browse", provider: Provider()) { entry in
            VStack {
                Items(items: entry.items)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(.systemIndigo))
                    Image(systemName: "magnifyingglass")
                        .font(Font.headline.bold())
                        .foregroundColor(.black)
                }
                .widgetURL(URL(string: "incognit-search://google.com")!)
                .frame(height: 40)
                .padding(.horizontal)
                .padding(.bottom)
            }.background(LinearGradient(gradient: Gradient(colors: [
                                                            Color(.init(srgbRed: 88/255, green: 86/255, blue: 214/255, alpha: 1)),
                                                            Color(.init(srgbRed: 104/255, green: 155/255, blue: 233/255, alpha: 1))]),
                                        startPoint: .top, endPoint: .bottom))
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}

private struct Items: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let items: [History.Item]
    
    var body: some View {
        VStack {
            if items.isEmpty {
                Spacer()
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(Color.black.opacity(0.2))
            } else {
                ForEach(0 ..< (family == .systemLarge ? items.count : 1)) {
                    Item(item: items[$0])
                }
            }
            Spacer()
        }.padding(.top)
    }
}

private struct Item: View {
    let item: History.Item
    
    var body: some View {
        Link(destination: item.open) {
            VStack {
                HStack {
                    Text(verbatim: item.title)
                        .font(.footnote)
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack {
                    Text(verbatim: item.url.absoluteString)
                        .font(.caption2)
                        .foregroundColor(Color.black.opacity(0.7))
                    Spacer()
                }
            }
            .frame(height: 55)
            .padding(.horizontal)
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
