import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var trackers = [URL]()
    
    var body: some View {
        NavigationView {
            List {
                if trackers.isEmpty {
                    Text("No trackers blocked")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(0 ..< trackers.count) {
                        Text(trackers[$0].absoluteString)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            trackers = session.state.blocked
        }
    }
}
