import SwiftUI

extension Detail {
    struct Item: View {
        let image: String
        let text: LocalizedStringKey
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.init(.secondarySystemBackground))
                    HStack {
                        Image(systemName: image)
                            .padding()
                        Text(text)
                            .font(.footnote)
                        Spacer()
                    }.padding(.horizontal)
                }.frame(height: 50)
            }
            .padding(.horizontal)
            .accentColor(.primary)
        }
    }
}
