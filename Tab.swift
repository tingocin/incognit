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
                    .offset(y: -5)
                    .animation(.easeInOut(duration: 0.3))
                Spacer()
            }
            if session.error != nil {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(Font.largeTitle.bold())
                        .padding(.bottom)
                    Text(verbatim: session.page?.url.absoluteString ?? "")
                        .bold()
                        .padding(.horizontal)
                    Text(verbatim: session.error!)
                        .font(.footnote)
                        .padding(.horizontal)
                }.foregroundColor(.secondary)
            }
            Web(session: $session)
            Tools(session: $session)
        }
    }
}
