import SwiftUI

struct Bar: View {
    @Binding var session: Session
    @State private var open = false
    @State private var text = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: -2, y: -2)
                .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: 2, y: 2)
                .foregroundColor(.init(.secondarySystemBackground))
            if !open {
                if session.progress == 0 {
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                } else {
                    Progress(progress: .init(session.progress))
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 16)
                }
            }
            TextField("Browse", text: $text, onCommit: {
                open = false
                withAnimation(.easeInOut(duration: 0.7)) {
                    session.browse(text)
                }
            }).textContentType(.URL)
                .keyboardType(.webSearch)
                .autocapitalization(.none)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal)
                .opacity(open ? 1 : 0)
        }.onTapGesture {
            guard !open else { return }
            open = true
            let field = UIApplication.shared.textField
            field?.becomeFirstResponder()
            if field?.text?.isEmpty == false {
                field?.selectAll(nil)
            }
        }.frame(width: open ? 150 : 80, height: 40)
    }
}
