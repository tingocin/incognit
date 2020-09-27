import SwiftUI

struct Forget: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                Button {
                    withAnimation(.easeInOut(duration: 1)) {
                        session.forget()
                    }
                    UIApplication.shared.forget()
                    visible = false
                } label: {
                    Text("Forget")
                        .font(.headline)
                }.foregroundColor(.primary)
                Button {
                    visible = false
                } label: {
                    Text("Cancel")
                        .font(.subheadline)
                }.foregroundColor(.secondary)
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Forget everything", displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
