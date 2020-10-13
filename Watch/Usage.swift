import SwiftUI

struct Usage: View {
    @ObservedObject var delegate: Delegate
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    Chart(values: delegate.chart)
                        .frame(height: 100)
                    HStack {
                        Text(verbatim: delegate.first)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Now")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                        .frame(height: 10)
                }
                Section {
                    Button {
                        withAnimation(.easeInOut(duration: 1)) {
//                            session.forget()
                        }
                        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
                    } label: {
                        Text("Forget everything")
                            .font(.headline)
                    }.foregroundColor(.primary)
                }
            }
        }
    }
}
