import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< session.state.blocked.count) {
                    Text(session.state.blocked[$0].absoluteString)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitle("Trackers", displayMode: .inline)
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
