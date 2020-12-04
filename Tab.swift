import SwiftUI
import WebKit

struct Tab: View {
    @Binding var session: Session

    var body: some View {
        ZStack {
            VStack {
                Progress(progress: .init(session.state.progress))
                    .foregroundColor(.accentColor)
                    .frame(height: 5)
                    .offset(y: -5)
                    .animation(.easeInOut(duration: 0.3))
                Spacer()
            }
            if session.state.error != nil {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.accentColor)
                    Text(verbatim: session.page?.url.absoluteString ?? "")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                    Text(verbatim: session.state.error!)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
            }
            Web(session: $session)
                .opacity(session.state.error == nil ? 1 : 0)
        }
    }
}
