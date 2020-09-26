import SwiftUI
import WebKit

struct Tab: View {
    @Binding var session: Session

    var body: some View {
        ZStack {
            Web(session: $session)
                .edgesIgnoringSafeArea(.all)
            Tools(session: $session)
        }.transition(.move(edge: .bottom))
    }
}
