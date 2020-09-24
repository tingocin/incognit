import SwiftUI

struct Options: View {
    @Binding var url: URL?
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    VStack {
                        HStack {
                            Text(verbatim: url?.absoluteString ?? "")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 50)
                }) {
                    Circle()
                }
            }.listStyle(GroupedListStyle())
                .navigationBarItems(trailing:
                    Button(action: {
                        self.visible = false
                    }) {
                        Text("Done")
                            .font(.callout)
                            .foregroundColor(.pink)
                            .padding()
                    })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
