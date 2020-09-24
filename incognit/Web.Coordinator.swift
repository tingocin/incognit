import SwiftUI
import WebKit
import Combine

extension Web {
    final class Coordinator: WKWebView, WKNavigationDelegate {
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
            
            view.session.navigate.sink { [weak self] in
                self?.load(.init(url: $0))
            }.store(in: &subs)
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.progress = 1
        }
        
        private func navigate(_ url: String) {
            _ = URL(string: url).map { load(.init(url: $0)) }
        }
    }
}
