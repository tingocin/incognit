import SwiftUI

struct Tools: View {
    @Binding var session: Session
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
                    Spring(open: $right, base: "line.horizontal.3", top: "square.and.arrow.up.fill", middle: "square.stack.3d.up.fill") {
                        options = true
                    } middleAction: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.page = nil
                        }
                    }.sheet(isPresented: $options) {
                        Options(session: $session, visible: $options)
                    }.padding(.trailing)
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
}
