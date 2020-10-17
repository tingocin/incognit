import SwiftUI

extension Detail {
    struct Options: View {
        @Binding var session: Session
        @Binding var visible: Bool
        @State private var done = false
        
        var body: some View {
            if ({
                switch $0 {
                case "png", "jpg", "jpeg", "bmp", "gif": return true
                default: return false
                }
            } (session.page!.url.pathExtension.lowercased())) {
                Item(image: "photo", text: "Add to Photos") {
                    (try? Data(contentsOf: session.page!.url)).flatMap(UIImage.init(data:)).map {
                        UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                        success()
                    }
                }
            }
            Item(image: "pencil", text: "Edit URL") {
                visible = false
                session.type.send(session.page!.url.absoluteString)
            }
            Item(image: "doc.on.doc", text: "Copy URL") {
                UIPasteboard.general.string = session.page!.url.absoluteString
                success()
            }
            Item(image: "square.and.arrow.up", text: "Share") {
                UIApplication.shared.share(session.page!.url)
            }
            Item(image: "square.and.arrow.down", text: "Download") {
                let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(session.page!.url.lastPathComponent)
                try? Data(contentsOf: session.page!.url).write(to: url, options: .atomic)
                UIApplication.shared.share(url)
            }
            Item(image: "printer", text: "Print") {
                session.print.send()
            }
            Item(image: "doc.plaintext", text: "PDF") {
                session.pdf.send()
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
}
