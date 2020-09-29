import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 30)
            HStack {
                Text(verbatim: session.page!.title)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }.padding(.horizontal)
            HStack {
                Text(verbatim: session.page!.url.absoluteString)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                Spacer()
            }.padding(.horizontal)
            Spacer()
                .frame(height: 30)
            HStack {
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = session.page!.url.absoluteString
                }, label: {
                    VStack {
                        Image(systemName: "doc.on.doc.fill")
                        Spacer()
                            .frame(height: 4)
                        Text("Copy URL")
                            .font(Font.footnote.bold())
                    }.padding()
                })
                Button(action: {
                    UIApplication.shared.share(session.page!.url)
                }, label: {
                    VStack {
                        Image(systemName: "square.and.arrow.up.fill")
                        Spacer()
                            .frame(height: 4)
                        Text("Share")
                            .font(Font.footnote.bold())
                    }.padding()
                })
                Spacer()
            }
            Spacer()
                .frame(height: 30)
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
