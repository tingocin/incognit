import SwiftUI
import WebKit

extension Web {
    final class Coordinator: WKWebView, WKNavigationDelegate {
        var last = "" {
            didSet {
                guard !last.contains("http") else {
                    navigate(last)
                    return
                }
                
                guard !last.contains(".") || last.last == "." else {
                    navigate("http://" + last)
                    return
                }
                
                navigate("https://www.ecosia.org/search?q=" + (last.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
            }
        }
        
        private var observations = Set<NSKeyValueObservation>()
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
            
            observations.insert(observe(\.estimatedProgress, options: .new) { [weak self] in
                $1.newValue.map { progress in
                    DispatchQueue.main.async {
                        self?.view.progress = .init(progress)
                    }
                }
            })
            
            observations.insert(observe(\.url, options: .new) { [weak self] in
                $1.newValue?.map { url in
                    DispatchQueue.main.async {
                        self?.view.url = url
                    }
                }
            })
        }
        
        deinit {
            observations.forEach { $0.invalidate() }
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.progress = 1
        }
        
        private func navigate(_ url: String) {
            _ = URL(string: url).map { load(.init(url: $0)) }
        }
    }
}
