import SwiftUI

struct Tools: View {
    @Binding var session: Session
    @State private var hide = true
    @State private var tabsY = CGFloat()
    @State private var menuY = CGFloat()
    @State private var options = false
    @State private var left = false
    @State private var right = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if hide {
                    HStack {
                        Control.Circle(selected: false, image: "chevron.left") {
                            session.backward.send()
                        }.opacity(session.backwards ? 1 : 0.6)
                            .padding(.leading)
                        Spacer()
//                        Control.Circle(selected: false, image: "chevron.right") {
//                            session.forward.send()
//                        }.opacity(session.forwards ? 1 : 0.6)
//                        .padding(.trailing)
                    }
                }
                HStack {
                    Spacer()
                    ZStack {
                        Control.Circle(selected: false, image: "square.stack.3d.up.fill") {
                            UIApplication.shared.resign()
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.page = nil
                            }
                        }
                        .offset(y: tabsY)
                        .opacity(right ? 1 : 0)
                        Control.Circle(selected: false, image: "line.horizontal.3") {
                            UIApplication.shared.resign()
                            show()
                            options = true
                        }
                        .offset(y: menuY)
                        .opacity(right ? 1 : 0)
                        .sheet(isPresented: $options) {
                                Options(session: $session, visible: $options)
                            }
                        Control.Circle(selected: right, image: "line.horizontal.3", action: toggleRight)
                    }
                    .padding(.trailing)
                }
                HStack {
                    Spacer()
                    Bar(session: $session)
                    Spacer()
                }
            }
        }.onReceive(session.redirect) {
            if !hide {
                show()
            }
        }
    }
    
    private func toggleRight() {
        if right {
            UIApplication.shared.resign()
            withAnimation(Animation.easeOut(duration: 0.2)) {
                tabsY = 0
                menuY = 0
                right = false
            }
        } else {
            right = true
            withAnimation(Animation.easeOut(duration: 0.2)) {
                tabsY = -75
            }
            withAnimation(Animation.easeOut(duration: 0.3)) {
                menuY = -150
            }
        }
    }
    
    
    
    
    private func show() {
        if hide {
            withAnimation(Animation.linear(duration: 0.2)) {
                hide = false
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
                hide = true
            }
        }
    }
}
