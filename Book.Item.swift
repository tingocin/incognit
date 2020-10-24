import SwiftUI

extension Book {
    struct Item: View {
        let page: Page
        let delete: () -> Void
        let action: () -> Void
        @State private var date = ""
        
        var body: some View {
            Button(action: action) {
                HStack {
                    VStack {
                        HStack {
                            Text(verbatim: page.title)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding(.leading)
                            Spacer()
                        }
                        HStack {
                            Text(verbatim: page.url.absoluteString)
                                .lineLimit(1)
                                .font(.footnote)
                                .foregroundColor(.init(.tertiaryLabel))
                                .padding(.leading)
                            Spacer()
                        }
                    }.padding(.vertical)
                    Text(verbatim: date)
                        .font(.caption2)
                        .foregroundColor(.init(.tertiaryLabel))
                        .offset(x: 15)
                    Control.Icon(image: "xmark", color: .init(.tertiaryLabel), action: delete)
                }
            }.onAppear {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute]
                formatter.unitsStyle = .short
                date = formatter.string(from: page.date, to: .init())!
            }
        }
    }
}
