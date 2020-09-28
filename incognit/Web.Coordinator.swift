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
            allowsBackForwardNavigationGestures = true
            scrollView.backgroundColor = .clear
            scrollView.keyboardDismissMode = .onDrag
            scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
            scrollView.automaticallyAdjustsScrollIndicatorInsets = true
            
            publisher(for: \.estimatedProgress).sink { [weak self] in
                self?.view.session.progress = $0
            }.store(in: &subs)
            
            publisher(for: \.title).sink { [weak self] in
                $0.map { title in
                    guard let page = self?.view.session.page, page.title != title else { return }
                    page.title = title
                    self?.view.session.save(page)
                }
            }.store(in: &subs)
            
            publisher(for: \.url).sink { [weak self] in
                $0.map { url in
                    guard let page = self?.view.session.page, page.url != url else { return }
                    page.url = url
                    self?.view.session.save(page)
                }
            }.store(in: &subs)
            
            publisher(for: \.canGoBack).sink { [weak self] in
                self?.view.session.backwards = $0
            }.store(in: &subs)
            
            publisher(for: \.canGoForward).sink { [weak self] in
                self?.view.session.forwards = $0
            }.store(in: &subs)
            
            publisher(for: \.scrollView.minimumZoomScale).debounce(for: .seconds(0.5), scheduler: DispatchQueue.main).filter { $0 < 1 }.sink { [weak self] in
                self?.scrollView.zoomScale = $0
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
            
            view.session.reload.sink { [weak self] in
                self?.reload()
            }.store(in: &subs)
            
            load(.init(url: view.session.page!.url))
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.progress = 0
        }
        
        private func navigate(_ url: String) {
            _ = URL(string: url).map { load(.init(url: $0)) }
        }
    }
}
