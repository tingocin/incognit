import SwiftUI

extension Detail {
    struct Shield: View {
        @Binding var session: Session
        @State private var trackers = false
        private let active = User.trackers
        
        var body: some View {
            Button {
                if active {
                    trackers = true
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 50)
                        .foregroundColor(active ? .accentColor : .clear)
                    HStack {
                        Text("Trackers blocked")
                            .font(.footnote)
                        Spacer()
                        if active {
                            Text(verbatim: "\(session.state.blocked.count)")
                                .font(Font.footnote.bold())
                        }
                        Image(systemName: active ? "shield.lefthalf.fill" : "shield.lefthalf.fill.slash")
                    }.padding()
                }.contentShape(Rectangle())
            }
            .foregroundColor(active ? .white : .primary)
            .padding(.horizontal)
            .sheet(isPresented: $trackers) {
                Trackers(session: $session, visible: $trackers)
            }.onReceive(session.dismiss) {
                trackers = false
            }
        }
    }
}
