import SwiftUI

struct Progress: Shape {
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: 0, y: rect.midY))
        path.addLine(to: .init(x: rect.width * progress, y: rect.midY))
        return path
    }
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
}
