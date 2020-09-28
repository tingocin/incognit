import SwiftUI

struct Move: View {
    @Binding var session: Session
    @State private var open = false
    @State private var refresh = CGFloat()
    @State private var back = CGFloat()
    @State private var forward = CGFloat()
    
    var body: some View {
        ZStack {
            Control.Circle(selected: false, image: "chevron.left") {
                UIApplication.shared.resign()
                session.backward.send()
            }
            .offset(x: back, y: refresh)
            .opacity(open ? session.backwards ? 1 : 0.5 : 0)
            Control.Circle(selected: false, image: "chevron.right") {
                UIApplication.shared.resign()
                session.forward.send()
            }
            .offset(x: forward, y: refresh)
            .opacity(open ? session.forwards ? 1 : 0.5 : 0)
            Control.Circle(selected: false, image: "arrow.clockwise.circle.fill") {
                UIApplication.shared.resign()
                session.reload.send()
            }
            .offset(y: refresh)
            .opacity(open ? 1 : 0)
            Control.Circle(selected: open, image: "move.3d") {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.3)) {
                    open.toggle()
                }
            }
        }.onChange(of: open) {
            if $0 {
                withAnimation(.easeInOut(duration: 0.2)) {
                    refresh = -75
                }
                withAnimation(Animation.easeInOut(duration: 0.2).delay(0.2)) {
                    back = 75
                }
                withAnimation(Animation.easeInOut(duration: 0.3).delay(0.2)) {
                    forward = 150
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    back = 0
                    forward = 0
                }
                withAnimation(Animation.easeInOut(duration: 0.2).delay(0.2)) {
                    refresh = 0
                }
            }
        }
    }
}
