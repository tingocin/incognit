import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var trackers = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if session.page != nil {
                    Title(session: $session)
                    Find(session: $session, visible: $visible)
                    Options(session: $session, trackers: $trackers, visible: $visible)
                }
            }
            .navigationBarTitle("Browsing", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        visible = false
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .frame(width: 40, height: 40)
                                            .contentShape(Rectangle())
                                    }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $trackers) {
            Trackers(session: $session, visible: $trackers)
        }.onReceive(session.dismiss) {
            trackers = false
        }
    }
}
