import SwiftUI

extension Control {
    struct Icon: View {
        let image: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: image)
                    .font(.footnote)
                    .foregroundColor(color)
                    .frame(width: 52, height: 52)
                    .contentShape(SwiftUI.Circle())
            }
        }
    }
}
