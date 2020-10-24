import WidgetKit
import SwiftUI

@main struct Browse: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Browse", provider: Provider()) { entry in
            ZStack {
                Log(items: entry.items)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(Font.body.bold())
                            .foregroundColor(.init(.systemIndigo))
                            .frame(width: 150, height: 40)
                            .padding(.bottom)
                        Spacer()
                    }
                }.widgetURL(URL(string: "incognit-search://")!)
            }.background(LinearGradient(gradient:
                                            .init(colors: [.init(.secondarySystemBackground),
                                                           .init(.systemBackground)]),
                                        startPoint: .top, endPoint: .bottom))
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}
