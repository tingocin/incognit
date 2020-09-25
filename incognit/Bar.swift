import SwiftUI

struct Bar: View {
    let engine: Engine
    let size: Size
    let tap: () -> Void
    let commit: (URL?) -> Void
    @State private var text = ""
    
    var body: some View {
        ZStack {
            if size.background {
                RoundedRectangle(cornerRadius: 20)
                    .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: -2, y: -2)
                    .shadow(color: .init(UIColor.systemBackground.withAlphaComponent(0.6)), radius: 4, x: 2, y: 2)
                    .foregroundColor(.init(.secondarySystemBackground))
            }
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .foregroundColor(.accentColor)
                .opacity(size.image ? 1 : 0)
            TextField(size.title, text: $text, onCommit: {
                commit(text.url(engine))
            }).textContentType(.URL)
                .keyboardType(.webSearch)
                .autocapitalization(.none)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal)
                .onTapGesture(perform: tap)
        }.frame(width: size.rawValue, height: 40)
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
