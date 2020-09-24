import SwiftUI

extension Control {
    struct Circle: View {
        let image: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                EmptyView()
            }.buttonStyle(Style { pressed in
                ZStack {
                    SwiftUI.Circle()
                        .frame(width: 40, height: 40)
                        .shadow(color: .init(.systemBackground), radius: 2, x: pressed ? 0 : -2, y: pressed ? 0 : -2)
                        .shadow(color: .init(.systemBackground), radius: 3, x: pressed ? 0 : 3, y: pressed ? 0 : 3)
                        .foregroundColor(pressed ? color : .init(.secondarySystemBackground))
                    Image(systemName: image)
                        .font(Font.headline.bold())
                        .foregroundColor(pressed ? .init(.systemBackground) : color)
                }.frame(width: 60, height: 60)
            })
        }
    }
}

private struct Style<Content>: ButtonStyle where Content : View {
    var hover: (Bool) -> Content
    
    func makeBody(configuration: Configuration) -> some View {
        hover(configuration.isPressed)
    }
}
