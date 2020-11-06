import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @State private var trackers = false
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            ScrollView {
                if session.page != nil {
                    Title(session: $session)
                    Find(session: $session)
                    Options(session: $session, trackers: $trackers)
                }
            }
            .navigationBarTitle("Browsing", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        visible.wrappedValue.dismiss()
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
            Trackers(session: $session)
        }.onReceive(session.dismiss) {
            trackers = false
        }
    }
}
