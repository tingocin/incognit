import SwiftUI

extension Control {
    struct Icon: View {
        let image: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: image)
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    
            }
            .contentShape(SwiftUI.Circle())
        }
    }
}
