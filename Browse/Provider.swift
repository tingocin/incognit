import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in: Context) -> History {
        .placerholder
    }

    func getSnapshot(in context: Context, completion: @escaping (History) -> ()) {
        completion(context.isPreview ? .placerholder : .latest)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<History>) -> ()) {
        completion(.init(entries: [.latest], policy: .never))
    }
}
