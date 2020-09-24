import SwiftUI

struct Tools: View {
    @Binding var session: Session
    @State private var editing = ""
    @State private var hide = true
    @State private var tabsY = CGFloat()
    @State private var menuY = CGFloat()
    @State private var barWidth = CGFloat()
    @State private var options = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Spacer()
                    Bar(text: $editing, width: barWidth, action: commit)
                    Spacer()
                }
                HStack {
                    Spacer()
                    ZStack {
                        Blob.Icon(icon: "square.on.square") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                session.current = nil
                            }
                        }.padding()
                            .offset(y: tabsY)
                        Blob.Icon(icon: "line.horizontal.3") {
                            self.show()
                            self.options = true
                        }.padding()
                            .offset(y: menuY)
//                            .sheet(isPresented: $options) {
//                                Options(url: self.$url, visible: self.$options)
//                        }
                        Blob.Icon(icon: hide ? "magnifyingglass" : "multiply", action: show)
                            .padding()
                    }
                    if hide {
                        Spacer()
                    }
                }
            }
        }.onAppear {
            if session.page?.url == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    show()
                    UIApplication.shared.textField.becomeFirstResponder()
                }
            } else {
                session.navigate.send(session.page!.url!)
            }
        }
    }
    
    private func show() {
        if hide {
            withAnimation(Animation.linear(duration: 0.2)) {
                hide = false
                barWidth = 200
            }
            withAnimation(Animation.easeOut(duration: 0.2).delay(0.1)) {
                menuY = -75
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.1)) {
                tabsY = -150
            }
        } else {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            withAnimation(Animation.easeOut(duration: 0.2)) {
                tabsY = 0
                menuY = 0
            }
            withAnimation(Animation.linear(duration: 0.2).delay(0.1)) {
                barWidth = 0
                hide = true
            }
        }
    }
    
    private func commit() {
        show()
        URL(string: url).map(session.navigate.send)
    }
    
    private var url: String {
        editing.fullURL ? editing :
            editing.url ? "http://" + editing : "https://www.ecosia.org/search?q=" + (editing.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}

private extension String {
    var fullURL: Bool {
        (contains("http://") || contains("https://")) && url
    }
    
    var url: Bool {
        {
            $0.count > 1 && $0.last!.count > 1 && $0.first!.count > 2
        } (components(separatedBy: "."))
    }
}
