import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
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
            Item(image: "doc.on.doc.fill", text: "Copy URL") {
                UIPasteboard.general.string = session.page!.url.absoluteString
            }
            Item(image: "square.and.arrow.up.fill", text: "Share") {
                UIApplication.shared.share(session.page!.url)
            }
            Item(image: "square.and.arrow.down.fill", text: "Download") {
                let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(session.page!.url.lastPathComponent)
                try? Data(contentsOf: session.page!.url).write(to: url, options: .atomic)
                UIApplication.shared.share(url)
            }
            Item(image: "printer.fill.and.paper.fill", text: "Print") {
                session.print.send()
            }
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
}
