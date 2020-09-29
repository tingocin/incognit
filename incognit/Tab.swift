import SwiftUI
import WebKit

struct Tab: View {
    @Binding var session: Session

    var body: some View {
        ZStack {
            VStack {
                Progress(progress: .init(session.progress))
                    .foregroundColor(.accentColor)
                    .frame(height: 5)
                    .offset(y: -6)
                    .animation(.easeInOut(duration: 0.3))
                Spacer()
            }
            Web(session: $session)
            Tools(session: $session)
        }.transition(.move(edge: .bottom))
    }
}
