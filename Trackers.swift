import SwiftUI

struct Trackers: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var trackers = [String]()
    
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
            trackers = Set(session.state.blocked
                            .filter { $0.scheme == "https" || $0.scheme == "http" }
                            .map {
                                $0.absoluteString.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
                            }.compactMap {
                                $0.components(separatedBy: "/").first
                            }).sorted()
        }
    }
}
