import SwiftUI
import WebKit

struct Tab: View {
    @Binding var session: Session
    @State private var progress = CGFloat(1)

    var body: some View {
        ZStack {
            VStack {
                Progress(progress: progress)
                    .stroke(progress < 1 ? Color.accentColor : .clear, style: .init(lineWidth: 4, lineCap: .round))
                    .frame(height: 4)
                    .cornerRadius(3)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                Web(session: $session, progress: $progress)
                    .opacity(session.page?.url == nil ? 0 : 1)
            }
            Tools(session: $session)
        }.transition(.move(edge: .bottom))
    }
}
