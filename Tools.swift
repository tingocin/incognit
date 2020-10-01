import SwiftUI

struct Tools: View {
    @Binding var session: Session
    @State private var spring = false
    @State private var detail = false
    @State private var detailY = CGFloat()
    @State private var reloadY = CGFloat()
    @State private var backwardX = CGFloat()
    @State private var forwardX = CGFloat()
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    ZStack {
                        Control.Circle(selected: false, image: "chevron.left") {
                            UIApplication.shared.resign()
                            session.backward.send()
                        }
                        .offset(x: backwardX)
                        .opacity(spring ? session.backwards ? 1 : 0.5 : 0)
                        Control.Circle(selected: false, image: "chevron.right") {
                            UIApplication.shared.resign()
                            session.forward.send()
                        }
                        .offset(x: forwardX)
                        .opacity(spring ? session.forwards ? 1 : 0.5 : 0)
                        Control.Circle(selected: false, image: "line.horizontal.3") {
                            UIApplication.shared.resign()
                            detail = true
                        }.sheet(isPresented: $detail) {
                            Detail(session: $session, visible: $detail)
                        }
                        .offset(y: detailY)
                        .opacity(spring ? 1 : 0)
                        Control.Circle(selected: false, image: "arrow.clockwise") {
                            UIApplication.shared.resign()
                            session.reload.send()
                        }
                        .opacity(spring ? 1 : 0)
                        .offset(y: reloadY)
                        Control.Circle(selected: spring, image: "plus") {
                            UIApplication.shared.resign()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                spring.toggle()
                            }
                        }
                    }.onChange(of: spring) {
                        if $0 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                reloadY = -75
                                backwardX = 75
                            }
                            withAnimation(.easeInOut(duration: 0.3)) {
                                detailY = -150
                                forwardX = 150
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                reloadY = 0
                                detailY = 0
                                backwardX = 0
                                forwardX = 0
                            }
                        }
                    }.padding(.leading)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Control.Circle(selected: false, image: "xmark") {
                        UIApplication.shared.resign()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            session.page = nil
                        }
                    }.padding(.trailing)
                }
                HStack {
                    Spacer()
                    Bar(session: $session)
                        .opacity(spring ? 0 : 1)
                    Spacer()
                }
            }
        }.onReceive(session.dismiss) {
            detail = false
        }
    }
}
