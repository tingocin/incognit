import SwiftUI

struct Usage: View {
    @State private var values = [CGFloat]()
    @State private var initial = ""
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    Chart(values: values)
                        .frame(height: 100)
                    HStack {
                        Text(verbatim: initial)
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
        .onAppear {
//            guard !session.pages.value!.isEmpty else { return }
//            let dates = session.pages.value!.map(\.date.timeIntervalSince1970)
//            let first = dates.min()!
//            let interval = (Date().timeIntervalSince1970 - first) / 5
//            let ranges = (0 ..< 5).map {
//                (.init($0) * interval) + first
//            }
//            let array = dates.reduce(into: Array(repeating: 0, count: 5)) {
//                var index = 0
//                while index < 4 && ranges[index + 1] < $1 {
//                    index += 1
//                }
//                $0[index] += 1
//            }
//            let top = CGFloat(array.max()!)
//            values = array.map { .init($0) / top }
//
//            let formatter = DateComponentsFormatter()
//            formatter.allowedUnits = [.day, .hour, .minute]
//            formatter.unitsStyle = .short
//            initial = formatter.string(from: Date(timeIntervalSince1970: first), to: .init())!
        }
    }
}
