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
                Image(systemName: "magnifyingglass")
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            TextField("Browse", text: $text, onCommit: {
                open = false
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

private extension String {
    func url(_ engine: Engine) -> URL? {
        {
            $0.isEmpty ? nil : URL(string: $0.content(engine))
        } (trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private func content(_ engine: Engine) -> Self {
        fullURL ? self : semiURL ? "http://" + self : engine.prefix + (addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    private var fullURL: Bool {
        (contains("http://") || contains("https://")) && semiURL
    }
    
    private var semiURL: Bool {
        {
            $0.count > 1 && $0.last!.count > 1 && $0.first!.count > 2
        } (components(separatedBy: "."))
    }
}
