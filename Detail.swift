import SwiftUI

struct Detail: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                if session.page != nil {
                    Title(session: $session)
                    Find(session: $session, visible: $visible)
                    Shield(session: $session)
                    Options(session: $session, visible: $visible)
                }
            }
            .navigationBarTitle("Browsing", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        visible = false
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.secondary)
                                            .frame(width: 40, height: 40)
                                            .contentShape(Rectangle())
                                    }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}
