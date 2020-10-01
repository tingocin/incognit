import SwiftUI

struct Bar: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 40)
                .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: -2, y: -2)
                .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: 2, y: 2)
                .foregroundColor(.init(.secondarySystemBackground))
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .foregroundColor(.accentColor)
                .opacity(session.typing ? 0 : 1)
            Field(session: $session)
                .padding(.trailing)
                .opacity(session.typing ? 1 : 0)
        }
        .onTapGesture(perform: type)
        .frame(width: session.typing ? 150 : 80, height: 40)
    }
    
    private func type() {
        session.type.send()
    }
}
