import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct BrowseEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct Browse: Widget {
    let kind: String = "Browse"
    @State private var text = ""

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: -2, y: -2)
                    .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: 2, y: 2)
                    .foregroundColor(.init(.secondarySystemBackground))
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }.frame(height: 40)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
