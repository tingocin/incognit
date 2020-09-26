import SwiftUI
import WebKit
import Combine

extension Web {
    final class Coordinator: WKWebView, WKNavigationDelegate, WKUIDelegate {
        private var subs = Set<AnyCancellable>()
        private let view: Web
        
        required init?(coder: NSCoder) { nil }
        init(view: Web) {
            self.view = view
            
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            configuration.ignoresViewportScaleLimits = true
            configuration.dataDetectorTypes = [.link, .phoneNumber]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            configuration.websiteDataStore = .nonPersistent()
            
            super.init(frame: .zero, configuration: configuration)
            navigationDelegate = self
            uiDelegate = self
            scrollView.contentInset.bottom = 100
            isOpaque = false
            backgroundColor = .clear
            scrollView.backgroundColor = .clear
            
            publisher(for: \.estimatedProgress).sink { [weak self] progress in
                DispatchQueue.main.async {
                    self?.view.progress = .init(progress)
                }
            }.store(in: &subs)
            
            publisher(for: \.title).sink { [weak self] in
                $0.map { title in
                    guard self?.view.session.page?.title != title else { return }
                    self?.view.session.update {
                        $0.title = title
                    }
                }
            }.store(in: &subs)
            
            publisher(for: \.url).sink { [weak self] in
                $0.map { url in
                    guard self?.view.session.page?.url != url else { return }
                    self?.view.session.update {
                        $0.url = url
                    }
                }
            }.store(in: &subs)
            
            publisher(for: \.canGoBack).sink { [weak self] in
                self?.view.session.backwards = $0
            }.store(in: &subs)
            
            publisher(for: \.canGoForward).sink { [weak self] in
                self?.view.session.forwards = $0
            }.store(in: &subs)
            
            view.session.navigate.sink { [weak self] in
                self?.load(.init(url: $0))
            }.store(in: &subs)
            
            view.session.backward.sink { [weak self] in
                self?.goBack()
            }.store(in: &subs)
            
            view.session.forward.sink { [weak self] in
                self?.goForward()
            }.store(in: &subs)
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.progress = 1
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            view.session.change.send()
        }
        
        private func navigate(_ url: String) {
            _ = URL(string: url).map { load(.init(url: $0)) }
        }
    }
}
