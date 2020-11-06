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
                            Text(verbatim: date)
                                .font(.footnote)
                                .foregroundColor(.init(.tertiaryLabel))
                        }
                    }.padding(.vertical)
                    Control.Icon(image: "xmark.circle.fill", color: .init(.tertiaryLabel), action: delete)
                }
            }.onAppear {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                formatter.unitsStyle = .short
                formatter.maximumUnitCount = 1
                date = formatter.string(from: page.date, to: .init())!
            }
        }
    }
}
