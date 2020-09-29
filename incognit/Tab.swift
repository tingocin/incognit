import SwiftUI
import WebKit

struct Tab: View {
    @Binding var session: Session

    var body: some View {
        ZStack {
            Web(session: $session)
            Tools(session: $session)
        }.transition(.move(edge: .bottom))
    }
}
