import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var done = false
    @State private var trackers = false
    @State private var find = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                if session.page != nil {
                    VStack {
                        Spacer()
                            .frame(height: 10)
                        HStack {
                            Text(verbatim: session.page!.title)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        HStack {
                            Text(verbatim: session.page!.url.absoluteString)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.footnote)
                                .foregroundColor(.init(.tertiaryLabel))
                            Spacer()
                        }
                    }.padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 50)
                            .foregroundColor(.init(.secondarySystemBackground))
                        HStack {
                            TextField("Find on Page", text: $find, onCommit: {
                                visible = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    session.find.send(find)
                                }
                            }).textContentType(.URL)
                                .keyboardType(.webSearch)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal)
                            Button(action: UIApplication.shared.resign) {
                                Text("Cancel")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding()
                                    .contentShape(Rectangle())
                            }
                        }
                    }.padding(.horizontal)
                    Button {
                        if User.trackers {
                            trackers = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 50)
                                .foregroundColor(User.trackers ? .accentColor : .clear)
                            HStack {
                                Text("Tracker blocked")
                                    .font(.footnote)
                                Spacer()
                                if User.trackers {
                                    Text(verbatim: "\(session.state.blocked.count)")
                                        .font(Font.footnote.bold())
                                }
                                Image(systemName: User.trackers ? "shield.lefthalf.fill" : "shield.lefthalf.fill.slash")
                            }.padding()
                        }.contentShape(Rectangle())
                    }
                    .foregroundColor(User.trackers ? .white : .primary)
                    .padding(.horizontal)
                    .sheet(isPresented: $trackers) {
                        Trackers(session: $session, visible: $trackers)
                    }
                    VStack {
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
            }
            .navigationBarTitle("Browsing", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        visible = false
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.secondary)
                                            .frame(width: 40, height: 40)
                                            .contentShape(Rectangle())
                                    }))
        }.onReceive(session.dismiss) {
            trackers = false
        }.navigationViewStyle(StackNavigationViewStyle())
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
