import SwiftUI
import WebKit
import Combine
import Tron

extension Web {
    final class Coordinator: WKWebView, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
        private var subs = Set<AnyCancellable>()
        private let tron = Tron()
        private let view: Web
        private let secure: Bool
        private let trackers: Bool
        private let javascript: Bool
        
        required init?(coder: NSCoder) { nil }
        init(view: Web) {
            let dark = User.dark
            let secure = User.secure
            let trackers = User.trackers
            let javascript = User.javascript
            
            let configuration = WKWebViewConfiguration()
            configuration.allowsAirPlayForMediaPlayback = true
            configuration.allowsInlineMediaPlayback = true
            configuration.ignoresViewportScaleLimits = true
            configuration.dataDetectorTypes = [.link]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = User.popups && javascript
            configuration.preferences.isFraudulentWebsiteWarningEnabled = secure
            configuration.websiteDataStore = .nonPersistent()
            
            if UIApplication.shared.windows.first!.rootViewController!.traitCollection.userInterfaceStyle == .dark && dark {
                configuration.userContentController.addUserScript(.init(source: Dark.script, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
            }
            
            if User.ads {
                configuration.userContentController.blockAds()
            }
            
            if User.cookies {
                configuration.userContentController.blockCookies()
            }
            
            self.secure = secure
            self.trackers = trackers
            self.javascript = javascript
            self.view = view
            super.init(frame: .zero, configuration: configuration)
            navigationDelegate = self
            uiDelegate = self
            allowsBackForwardNavigationGestures = true
            scrollView.keyboardDismissMode = .onDrag
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
            isOpaque = !dark && traitCollection.userInterfaceStyle == .dark
            
            publisher(for: \.estimatedProgress).sink { [weak self] in
                self?.view.session.state.progress = $0
            }.store(in: &subs)
            
            publisher(for: \.title).sink { [weak self] in
                $0.map {
                    guard !$0.isEmpty else { return }
                    self?.view.session.page?.title = $0
                    self?.view.session.save.send(self?.view.session.page)
                }
            }.store(in: &subs)
            
            publisher(for: \.url).sink { [weak self] in
                $0.map {
                    self?.view.session.page?.url = $0
                    self?.view.session.save.send(self?.view.session.page)
                }
            }.store(in: &subs)
            
            publisher(for: \.canGoBack).sink { [weak self] in
                self?.view.session.state.backwards = $0
            }.store(in: &subs)
            
            publisher(for: \.canGoForward).sink { [weak self] in
                self?.view.session.state.forwards = $0
            }.store(in: &subs)
            
            view.session.navigate.sink { [weak self] in
                self?.open($0)
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
            
            view.session.print.sink { [weak self] in
                UIPrintInteractionController.shared.printFormatter = self?.viewPrintFormatter()
                UIPrintInteractionController.shared.present(animated: true)
            }.store(in: &subs)
            
            view.session.pdf.sink { [weak self] in
                self?.createPDF {
                    if case .success(let data) = $0 {
                        guard var name = self?.view.session.page?.url.lastPathComponent.replacingOccurrences(of: "/", with: "") else { return }
                        if name.isEmpty {
                            name = "Page.pdf"
                        } else if !name.hasSuffix(".pdf") {
                            name = {
                                $0.count > 1 ? $0.dropLast().joined(separator: ".") : $0.first!
                            } (name.components(separatedBy: ".")) + ".pdf"
                        }
                        UIApplication.shared.share(data.temporal(name))
                    }
                }
            }.store(in: &subs)
            
            view.session.find.sink { [weak self] in
                self?.select(nil)
                self?.find($0) { _ in }
            }.store(in: &subs)
            
            open(view.session.page!.url)
        }
        
        deinit {
            uiDelegate = nil
            navigationDelegate = nil
            scrollView.delegate = nil
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            view.session.state.error = nil
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.state.progress = 1
        }
        
        func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            if let error = withError as? URLError {
                switch error.code {
                case .networkConnectionLost,
                     .notConnectedToInternet,
                     .dnsLookupFailed,
                     .resourceUnavailable,
                     .unsupportedURL,
                     .cannotFindHost,
                     .cannotConnectToHost,
                     .timedOut,
                     .secureConnectionFailed,
                     .serverCertificateUntrusted:
                    view.session.state.error = error.localizedDescription
                default: break
                }
            } else if (withError as NSError).code == 101 {
                view.session.state.error = withError.localizedDescription
            }
            view.session.state.progress = 1
        }
        
        func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard secure else {
                completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
                return
            }
            completionHandler(.performDefaultHandling, nil)
        }
        
        func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if action.targetFrame == nil && action.navigationType == .linkActivated {
                action.request.url.map(view.session.navigate.send)
            }
            return nil
        }
        
        func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            var sub: AnyCancellable?
            sub = tron.policy(for: decidePolicyFor.request.url!, shield: trackers).receive(on: DispatchQueue.main).sink { [weak self] in
                sub?.cancel()
                switch $0 {
                case .allow:
                    print("allow \(decidePolicyFor.request.url!)")
                    preferences.allowsContentJavaScript = self?.javascript ?? false
                    decisionHandler(.allow, preferences)
                case .external:
                    print("external \(decidePolicyFor.request.url!)")
                    decisionHandler(.cancel, preferences)
                    UIApplication.shared.open(decidePolicyFor.request.url!)
                case .ignore:
                    decisionHandler(.cancel, preferences)
                case .block(let domain):
                    decisionHandler(.cancel, preferences)
                    self?.view.session.state.blocked.insert(domain)
                }
            }
        }
        
        private func open(_ url: URL) {
            guard url.deeplink else {
                load(.init(url: url))
                return
            }
            UIApplication.shared.open(url)
        }
    }
}
