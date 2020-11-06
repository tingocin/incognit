import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @State private var trackers = [String]()
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            List {
                if trackers.isEmpty {
                    HStack {
                        Spacer()
                        Image(systemName: "shield.lefthalf.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                            .padding()
                        Spacer()
                    }.padding(.vertical)
                } else {
                    ForEach(0 ..< trackers.count) {
                        Text(trackers[$0])
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("Trackers", displayMode: .inline)
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
        .onAppear {
            trackers = session.state.blocked.sorted()
        }
    }
}
