import SwiftUI

struct Bar: View {
    @Binding var text: String
    let width: CGFloat
    var action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: width == 0 ? 0 : width + 20, height: 40)
                .shadow(color: .init(.systemBackground), radius: 2, x: -2, y: -2)
                .shadow(color: .init(.systemBackground), radius: 3, x: 3, y: 3)
                .foregroundColor(.init(.secondarySystemBackground))
            HStack {
                Spacer()
                TextField("Search or website", text: $text, onCommit: action)
                    .textContentType(.URL)
                    .keyboardType(.webSearch)
                    .autocapitalization(.none)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(width: width, height: 40)
                    .onTapGesture {
                        UIApplication.shared.textField.selectAll(nil)
                }
                Spacer()
            }
        }
    }
}
