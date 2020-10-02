import SwiftUI

extension Control {
    struct Circle: View {
        let state = State.ready
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                EmptyView()
            }.buttonStyle(Style(state: state) { current in
                ZStack {
                    SwiftUI.Circle()
                        .frame(width: 40, height: 40)
                        .shadow(color: Color.black.opacity(0.6), radius: current == .disabled ? 0 : 3, x: -2, y: -2)
                        .shadow(color: Color.black.opacity(0.6), radius: current == .disabled ? 0 : 3, x: 2, y: 2)
                        .foregroundColor(state == .selected ? .init(.secondarySystemBackground) : .accentColor)
                    Image(systemName: image)
                        .font(Font.headline.bold())
                        .foregroundColor(state == .selected ? .accentColor : .black)
                }.frame(width: 60, height: 60)
            })
        }
    }
}

private struct Style<Content>: ButtonStyle where Content : View {
    let state: Control.State
    let current: (Control.State) -> Content
    
    func makeBody(configuration: Configuration) -> some View {
        current(state != .disabled && configuration.isPressed ? .selected : state)
    }
}
