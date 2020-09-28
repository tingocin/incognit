import SwiftUI

struct Progress: Shape {
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        .init {
            $0.addRect(.init(x: 0, y: 0, width: rect.width * progress, height: rect.height))
        }
    }
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
}
