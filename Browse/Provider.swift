import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Shared.Timeline {
        .placerholder
    }

    func getSnapshot(in context: Context, completion: @escaping (Shared.Timeline) -> ()) {
        completion(context.isPreview ? .placerholder : .latest)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Shared.Timeline>) -> ()) {
        completion(.init(entries: [.latest], policy: .never))
    }
}
