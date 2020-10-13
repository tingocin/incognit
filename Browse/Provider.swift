import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Shared {
        .placerholder
    }

    func getSnapshot(in context: Context, completion: @escaping (Shared) -> ()) {
        completion(context.isPreview ? .placerholder : .latest)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Shared>) -> ()) {
        completion(.init(entries: [.latest], policy: .never))
    }
}
