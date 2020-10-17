import SwiftUI

extension Detail {
    struct Title: View {
        @Binding var session: Session
        
        var body: some View {
            VStack {
                Spacer()
                    .frame(height: 10)
                HStack {
                    Text(verbatim: session.page!.title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                HStack {
                    Text(verbatim: session.page!.url.absoluteString)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.footnote)
                        .foregroundColor(.init(.tertiaryLabel))
                    Spacer()
                }
            }.padding()
        }
    }
}
