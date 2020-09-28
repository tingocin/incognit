import SwiftUI

struct Spring: View {
    let share: () -> Void
    let tabs: () -> Void
    @State private var open = false
    @State private var shareY = CGFloat()
    @State private var tabsY = CGFloat()
    
    var body: some View {
        ZStack {
            Control.Circle(selected: false, image: "square.and.arrow.up.fill") {
                UIApplication.shared.resign()
                share()
            }
            .offset(y: shareY)
            .opacity(open ? 1 : 0)
            Control.Circle(selected: false, image: "square.stack.3d.up.fill") {
                UIApplication.shared.resign()
                tabs()
            }
            .opacity(open ? 1 : 0)
            .offset(y: tabsY)
            Control.Circle(selected: open, image: "line.horizontal.3") {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.3)) {
                    open.toggle()
                }
            }
        }.onChange(of: open) {
            if $0 {
                withAnimation(.easeInOut(duration: 0.2)) {
                    tabsY = -75
                }
                withAnimation(.easeInOut(duration: 0.3)) {
                    shareY = -150
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    tabsY = 0
                    shareY = 0
                }
            }
        }
    }
}
