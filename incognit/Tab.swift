import SwiftUI
import WebKit

struct Tab: View {
    @Binding var session: Session
    @State private var progress = CGFloat()

    var body: some View {
        ZStack {
            Web(session: $session, progress: $progress)
                .edgesIgnoringSafeArea(.all)
            if progress > 0 && progress < 1 {
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.init(.systemBackground))
                            .frame(height: 10)
                        Progress(progress: progress)
                            .stroke(Color.accentColor, style: .init(lineWidth: 6, lineCap: .round))
                            .padding(.horizontal, 4)
                            .frame(height: 6)
                            .cornerRadius(3)
                            .animation(.easeInOut(duration: 0.6))
                    }
                    Spacer()
                }
            }
            Tools(session: $session)
        }.transition(.move(edge: .bottom))
    }
}
