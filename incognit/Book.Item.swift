import SwiftUI

extension Book {
    struct Item: View {
        let page: Page
        let delete: () -> Void
        let action: () -> Void
        @State private var date = ""
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.init(.tertiarySystemBackground))
                    HStack {
                        VStack {
                            HStack {
                                Text(verbatim: page.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.top)
                                    .padding(.leading)
                                Spacer()
                            }
                            HStack {
                                Text(verbatim: page.url.absoluteString)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .padding(.leading)
                                Spacer()
                            }
                            HStack {
                                Text(verbatim: date)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                        Control.Icon(image: "xmark", color: .init(.tertiaryLabel), action: delete)
                    }
                }.padding(.horizontal)
            }.onAppear {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute]
                formatter.unitsStyle = .short
                date = formatter.string(from: page.date, to: .init())!
            }
        }
    }
}
