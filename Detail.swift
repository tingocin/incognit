import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var done = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                    .frame(height: 30)
                HStack {
                    Text(verbatim: session.page!.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.title3.bold())
                        .foregroundColor(.primary)
                    Spacer()
                }.padding(.horizontal)
                HStack {
                    Text(verbatim: session.page!.url.absoluteString)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.footnote)
                        .foregroundColor(.init(.tertiaryLabel))
                    Spacer()
                }.padding(.horizontal)
                Spacer()
                    .frame(height: 20)
            }
            Item(image: "doc.on.doc.fill", text: "Copy URL") {
                UIPasteboard.general.string = session.page!.url.absoluteString
                success()
            }
            Item(image: "square.and.arrow.up.fill", text: "Share") {
                UIApplication.shared.share(session.page!.url)
            }
            Item(image: "square.and.arrow.down.fill", text: "Download") {
                let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(session.page!.url.lastPathComponent)
                try? Data(contentsOf: session.page!.url).write(to: url, options: .atomic)
                UIApplication.shared.share(url)
            }
            if ({
                switch $0 {
                case "png", "jpg", "jpeg", "bmp", "gif": return true
                default: return false
                }
            } (session.page!.url.pathExtension.lowercased())) {
                Item(image: "photo.fill.on.rectangle.fill", text: "Add to Photos") {
                    (try? Data(contentsOf: session.page!.url)).flatMap(UIImage.init(data:)).map {
                        UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                        success()
                    }
                }
            }
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .font(Font.title.bold())
                    .foregroundColor(.accentColor)
                    .padding(.vertical)
                Spacer()
                    .frame(width: 5)
                Text("Done")
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()
            }.opacity(done ? 1 : 0)
            Spacer()
            HStack {
                Spacer()
                Control.Icon(image: "arrow.down.circle.fill", color: .accentColor, font: .title) {
                    visible = false
                }.padding()
                Spacer()
            }
        }
    }
    
    private func success() {
        withAnimation(.easeInOut(duration: 0.3)) {
            done = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                done = false
            }
        }
    }
}
