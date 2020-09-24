import SwiftUI
import WebKit

struct Tab: View {
    @State private var text = ""
    @State private var progress = CGFloat(1)
    @State private var url: URL?

    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "eyeglasses")
                    .font(Font.largeTitle.bold())
                Text("incognit")
                    .font(.headline)
            }.foregroundColor(.init(.quaternaryLabel))
            VStack {
                Progress(progress: progress)
                    .stroke(progress < 1 ? Color.pink : .clear,
                            style: .init(lineWidth: 4, lineCap: .round))
                    .frame(height: 4)
                    .cornerRadius(3)
                    .padding(.horizontal, 20)
                Web(text: $text, url: $url, progress: $progress)
                    .opacity(text.isEmpty ? 0 : 1)
            }
            Tools(text: $text, url: $url)
        }
    }
}
