import SwiftUI

struct Options: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text(verbatim: session.current!.url.absoluteString)
                        .foregroundColor(.primary)
                    Spacer()
                }
            }.listStyle(GroupedListStyle())
                .navigationBarItems(trailing:
                    Button(action: {
                        visible = false
                    }) {
                        Text("Done")
                            .font(.callout)
                            .foregroundColor(.accentColor)
                            .padding()
                    })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
