import SwiftUI

struct Bar: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.init(.sRGB, white: 0, opacity: 0.00001))
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 40)
                .shadow(color: Color.black.opacity(0.6), radius: 3, x: -2, y: -2)
                .shadow(color: Color.black.opacity(0.6), radius: 3, x: 2, y: 2)
                .foregroundColor(session.typing ? .init(.secondarySystemBackground) : .accentColor)
            Image(systemName: "magnifyingglass")
                .font(Font.headline.bold())
                .foregroundColor(.black)
                .opacity(session.typing ? 0 : 1)
            Field(session: $session)
                .padding(.trailing)
                .opacity(session.typing ? 1 : 0)
        }
        .frame(width: session.typing ? 200 : 80, height: 70)
        .onTapGesture {
            session.type.send(nil)
        }
    }
}
