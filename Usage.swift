import SwiftUI
import WebKit

struct Usage: View {
    @Binding var session: Session
    @Binding var visible: Bool
    @State private var values = [CGFloat]()
    @State private var first = ""
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    Chart(values: values)
                        .frame(height: 140)
                    HStack {
                        Text(verbatim: first)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Now")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                        .frame(height: 10)
                }.listRowBackground(Color(UIColor.systemBackground))
                Section {
                    Button {
                        withAnimation(.easeInOut(duration: 1)) {
                            session.forget()
                        }
                        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
                        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
                        visible = false
                    } label: {
                        Text("Forget everything")
                            .font(.headline)
                    }.foregroundColor(.primary)
                }
                Section(footer:
                            HStack {
                                Spacer()
                                Control.Icon(image: "arrow.down.circle.fill", color: .accentColor, font: .title) {
                                    visible = false
                                }.padding()
                                Spacer()
                            }) {
                    EmptyView()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Usage", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            (Shared.get(.chart) as? [CGFloat]).map {
                values = $0
            }
            (Shared.get(.first) as? String).map {
                first = $0
            }
        }
    }
}
