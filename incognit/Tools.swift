import SwiftUI

struct Tools: View {
    @Binding var session: Session
    @State private var size = Bar.Size.hidden
    @State private var hide = true
    @State private var tabsY = CGFloat()
    @State private var menuY = CGFloat()
    @State private var options = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Spacer()
                    Bar(session: $session, size: size) {
                        UIApplication.shared.textField.selectAll(nil)
                    } commit: {
                        show()
                        $0.map(session.navigate.send)
                    }
                    Spacer()
                }
                if hide {
                    HStack {
                        Control.Circle(image: "chevron.left") {
                            session.backward.send()
                        }.opacity(session.backwards ? 1 : 0.6)
                            .padding(.leading)
                        Spacer()
                        Control.Circle(image: "chevron.right") {
                            session.forward.send()
                        }.opacity(session.forwards ? 1 : 0.6)
                        .padding(.trailing)
                    }
                }
                HStack {
                    Spacer()
                    ZStack {
                        Control.Circle(image: "square.stack.3d.up.fill") {
                            UIApplication.shared.resign()
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.page = nil
                            }
                        }.padding(.trailing)
                            .offset(y: tabsY)
                            .opacity(hide ? 0 : 1)
                        Control.Circle(image: "line.horizontal.3") {
                            UIApplication.shared.resign()
                            show()
                            options = true
                        }.padding(.trailing)
                            .offset(y: menuY)
                            .opacity(hide ? 0 : 1)
                            .sheet(isPresented: $options) {
                                Options(session: $session, visible: $options)
                            }
                        Control.Circle(image: hide ? "magnifyingglass" : "multiply", action: show)
                            .padding(.trailing)
                    }
                    if hide {
                        Spacer()
                    }
                }
            }
        }.onAppear {
            session.navigate.send(session.page!.url)
        }.onReceive(session.redirect) {
            if !hide {
                show()
            }
        }
    }
    
    private func show() {
        if hide {
            withAnimation(Animation.linear(duration: 0.2)) {
                hide = false
                size = .full
            }
            withAnimation(Animation.easeOut(duration: 0.2).delay(0.1)) {
                menuY = -75
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.1)) {
                tabsY = -150
            }
        } else {
            UIApplication.shared.resign()
            withAnimation(Animation.easeOut(duration: 0.2)) {
                tabsY = 0
                menuY = 0
            }
            withAnimation(Animation.linear(duration: 0.2).delay(0.1)) {
                size = .hidden
                hide = true
            }
        }
    }
}
