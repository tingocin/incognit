import SwiftUI
import WebKit

struct Settings: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var selected = Engine.ecosia
    
    var body: some View {
        NavigationView {
            List {
                Picker("", selection: $selected) {
                    Text("Ecosia")
                        .tag(Engine.ecosia)
                    Text("Google")
                        .tag(Engine.google)
                }.pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                    .padding()
                Button {
                    visible = false
                } label: {
                    Text("Done")
                        .font(.subheadline)
                }.foregroundColor(.secondary)
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Search engine", displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            selected = session.user!.engine
        }
        .onChange(of: selected) {
            session.user!.engine = $0
            session.save(session.user!)
        }
    }
}
