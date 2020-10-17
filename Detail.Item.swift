import SwiftUI

extension Detail {
    struct Item: View {
        let image: String
        let text: LocalizedStringKey
        var caption: String?
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.init(.secondarySystemBackground))
                    HStack {
                        Text(text)
                            .font(.footnote)
                        Spacer()
                        if caption != nil {
                            Text(verbatim: caption!)
                                .font(Font.footnote.bold())
                        }
                        Image(systemName: image)
                    }
                    .padding(.horizontal)
                    .foregroundColor(.primary)
                }
                .frame(height: 50)
            }
            .padding(.horizontal)
        }
    }
}
