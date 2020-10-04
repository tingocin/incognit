import SwiftUI
import WebKit

struct Usage: View {
    @Binding var session: Session
    @Binding var visible: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                            VStack {
                                Spacer()
                                    .frame(height: 10)
                                Chart(values: [0.2, 0.4, 0.3, 0.1, 0.5])
                                Spacer()
                                    .frame(height: 10)
                            }) {
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
