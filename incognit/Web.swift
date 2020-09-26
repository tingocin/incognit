import SwiftUI
import WebKit

struct Web: UIViewRepresentable {
    @Binding var session: Session
    
    func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        context.coordinator
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
