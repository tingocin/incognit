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
                    Bar(size: size) {
                        UIApplication.shared.textField.selectAll(nil)
                    } commit: {
                        show()
                        $0.map(session.navigate.send)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    ZStack {
                        Control.Circle(image: "square.on.square") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                session.current = nil
                            }
                        }.padding()
                            .offset(y: tabsY)
                        Control.Circle(image: "line.horizontal.3") {
                            show()
                            options = true
                        }.padding()
                            .offset(y: menuY)
                            .sheet(isPresented: $options) {
                                Options(session: $session, visible: $options)
                        }
                        Control.Circle(image: hide ? "magnifyingglass" : "multiply", action: show)
                            .padding()
                    }
                    if hide {
                        Spacer()
                    }
                }
            }
        }.onAppear {
            session.navigate.send(session.page!.url)
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
