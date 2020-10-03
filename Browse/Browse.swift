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
                                .foregroundColor(.black)
                            Image(systemName: "magnifyingglass")
                                .font(Font.headline.bold())
                                .foregroundColor(.init(.systemIndigo))
                        }
                        .widgetURL(URL(string: "incognit-search://google.com")!)
                        .frame(width: 80, height: 40)
                        .padding(.bottom)
                        Spacer()
                    }
                }
            }.background(LinearGradient(gradient:
                                            .init(colors: [.init(.init(srgbRed: 0.345, green: 0.313, blue: 0.839, alpha: 1.0)),
                                                           .init(.init(srgbRed: 0.407, green: 0.607, blue: 0.913, alpha: 1.0))]),
                                        startPoint: .top, endPoint: .bottom))
        }
        .configurationDisplayName("Browse")
        .description("incognit quick access")
    }
}
