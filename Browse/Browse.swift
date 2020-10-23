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
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.init(.systemIndigo))
                            Image(systemName: "magnifyingglass")
                                .font(Font.headline.bold())
                                .foregroundColor(.black)
                        }
                        .widgetURL(URL(string: "incognit-search://google.com")!)
                        .frame(width: 80, height: 40)
                        .padding(.bottom)
                        Spacer()
                    }
                }
            }.background(LinearGradient(gradient:
                                            .init(colors: [.init(.secondarySystemBackground),
                                                           .init(.systemBackground)]),
                                        startPoint: .top, endPoint: .bottom))
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}
