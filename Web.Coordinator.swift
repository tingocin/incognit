import SwiftUI
import WebKit
import Combine
import Tron

extension Web {
    final class Coordinator: WKWebView, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
        private var subs = Set<AnyCancellable>()
        private let view: Web
        private let javascript = User.javascript
        private let popups = User.popups
        private let secure = User.secure
        private let ads = User.ads
        private let cookies = User.cookies
        private let trackers = User.trackers
        private let tron = Tron()
        
        required init?(coder: NSCoder) { nil }
        init(view: Web) {
            self.view = view
            super.init(frame: .zero, configuration: WKWebViewConfiguration())
            configuration.allowsInlineMediaPlayback = true
            configuration.ignoresViewportScaleLimits = true
            configuration.dataDetectorTypes = [.link, .phoneNumber]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = popups && javascript
            configuration.preferences.isFraudulentWebsiteWarningEnabled = secure
            configuration.websiteDataStore = .nonPersistent()
            
            navigationDelegate = self
            uiDelegate = self
            allowsBackForwardNavigationGestures = true
            scrollView.keyboardDismissMode = .onDrag
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
            
            HTTPCookieStorage.shared.cookieAcceptPolicy = .never
            
            if ads {
                configuration.userContentController.blockAds()
            }
            
            if cookies {
                configuration.userContentController.blockCookies()
            }
            
            publisher(for: \.estimatedProgress).sink { [weak self] in
                self?.view.session.progress = $0
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
                        UIApplication.shared.share(data)
                    }
                }
            }.store(in: &subs)
            
            view.session.find.sink { [weak self] in
                self?.select(nil)
                self?.find($0) { _ in }
            }.store(in: &subs)
            
            load(.init(url: view.session.page!.url))
        }
        
        deinit {
            uiDelegate = nil
            navigationDelegate = nil
            scrollView.delegate = nil
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            view.session.error = nil
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.progress = 1
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
                    view.session.error = error.localizedDescription
                default: break
                }
            } else if (withError as NSError).code == 101 {
                view.session.error = withError.localizedDescription
            }
        }
        
        func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard secure else {
                completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
                return
            }
            completionHandler(.performDefaultHandling, nil)
        }
        
        func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if action.targetFrame == nil {
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
                    preferences.allowsContentJavaScript = self?.javascript ?? false
                    decisionHandler(.allow, preferences)
                case .deny:
                    decisionHandler(.cancel, preferences)
                case .external:
                    decisionHandler(.cancel, preferences)
                    self?.view.session.progress = 0
                    UIApplication.shared.open(decidePolicyFor.request.url!)
                }
            }
        }
    }
}
