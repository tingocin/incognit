import SwiftUI

struct Tools: View {
    @Binding var session: Session
    @State private var spring = false
    @State private var detail = false
    @State private var usage = false
    @State private var settings = false
    @State private var detailY = CGFloat()
    @State private var reloadY = CGFloat()
    @State private var backwardX = CGFloat()
    @State private var forwardX = CGFloat()
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if session.page != nil {
                    HStack {
                        ZStack {
                            Control.Circle(state: session.state.backwards ? .ready : .disabled, image: "chevron.left") {
                                session.resign.send()
                                session.backward.send()
                            }
                            .offset(x: backwardX)
                            .opacity(spring ? 1 : 0)
                            Control.Circle(state: session.state.forwards ? .ready : .disabled, image: "chevron.right") {
                                session.resign.send()
                                session.forward.send()
                            }
                            .offset(x: forwardX)
                            .opacity(spring ? 1 : 0)
                            Control.Circle(image: "line.horizontal.3") {
                                session.resign.send()
                                detail = true
                            }.sheet(isPresented: $detail) {
                                Detail(session: $session, visible: $detail)
                            }
                            .offset(y: detailY)
                            .opacity(spring ? 1 : 0)
                            Control.Circle(image: "arrow.clockwise") {
                                session.resign.send()
                                session.reload.send()
                            }
                            .opacity(spring ? 1 : 0)
                            .offset(y: reloadY)
                            Control.Circle(state: spring ? .selected : .ready, image: "plus") {
                                session.resign.send()
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
                        Control.Circle(image: "xmark") {
                            session.resign.send()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                spring = false
                                session.page = nil
                            }
                        }.padding(.trailing)
                    }
                }
                HStack {
                    Spacer()
                    if session.page == nil {
                        Control.Circle(image: "eyeglasses") {
                            session.resign.send()
                            usage = true
                        }.sheet(isPresented: $usage) {
                            Usage(session: $session, visible: $usage)
                        }.padding(.leading)
                    }
                    Bar(session: $session)
                        .opacity(spring ? 0 : 1)
                    if session.page == nil {
                        Control.Circle(image: "gearshape.fill") {
                            session.resign.send()
                            settings = true
                        }.sheet(isPresented: $settings) {
                            Settings(session: $session, visible: $settings)
                        }.padding(.trailing)
                    }
                    Spacer()
                }
            }
        }.onReceive(session.dismiss) {
            spring = false
            detail = false
            usage = false
            settings = false
        }
    }
}
