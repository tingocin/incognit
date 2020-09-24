import SwiftUI

struct Bar: View {
    let size: Size
    let tap: () -> Void
    let commit: (URL?) -> Void
    @State private var text = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .shadow(color: .init(.systemBackground), radius: 2, x: -2, y: -2)
                .shadow(color: .init(.systemBackground), radius: 3, x: 3, y: 3)
                .foregroundColor(.init(.secondarySystemBackground))
            Image(systemName: "magnifyingglass")
                .font(.headline)
                .foregroundColor(.accentColor)
                .opacity(size.image ? 1 : 0)
            TextField(size.title, text: $text, onCommit: {
                commit(text.url)
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
    var url: URL? {
        {
            $0.isEmpty ? nil : URL(string: $0.content)
        } (trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var content: Self {
        fullURL ? self : semiURL ? "http://" + self : "https://www.ecosia.org/search?q=" + (addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
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
