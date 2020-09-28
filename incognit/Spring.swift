import SwiftUI

struct Spring: View {
    @Binding var open: Bool
    let base: String
    let top: String
    let middle: String
    let topAction: () -> Void
    let middleAction: () -> Void
    @State private var topY = CGFloat()
    @State private var middleY = CGFloat()
    
    var body: some View {
        ZStack {
            Control.Circle(selected: false, image: top) {
                UIApplication.shared.resign()
                topAction()
            }
            .offset(y: topY)
            .opacity(open ? 1 : 0)
            Control.Circle(selected: false, image: middle) {
                UIApplication.shared.resign()
                middleAction()
            }
            .offset(y: middleY)
            .opacity(open ? 1 : 0)
            Control.Circle(selected: open, image: base) {
                UIApplication.shared.resign()
                open.toggle()
            }
        }.onChange(of: open) {
            if $0 {
                withAnimation(.easeOut(duration: 0.2)) {
                    middleY = -75
                }
                withAnimation(.easeOut(duration: 0.3)) {
                    topY = -150
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    topY = 0
                    middleY = 0
                }
            }
        }
    }
}
