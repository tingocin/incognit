import SwiftUI

extension Book {
    struct Item: View {
        let page: Page
        let action: () -> Void
        @State private var date = ""
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.init(.secondarySystemBackground))
                    VStack {
                        HStack {
                            Text(verbatim: page.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.top)
                                .padding(.leading)
                            Spacer()
                        }
                        if page.url != nil {
                            HStack {
                                Text(verbatim: page.url!.absoluteString)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                        HStack {
                            Spacer()
                            Text(verbatim: date)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.bottom)
                                .padding(.trailing)
                        }
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
