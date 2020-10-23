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
        private let dark = User.dark
        private let tron = Tron()
        
        required init?(coder: NSCoder) { nil }
        init(view: Web) {
            self.view = view
            super.init(frame: .zero, configuration: WKWebViewConfiguration())
            configuration.allowsAirPlayForMediaPlayback = true
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
            
            HTTPCookieStorage.shared.cookieAcceptPolicy = cookies ? .never : .always
            
            if dark {
                isOpaque = false
                backgroundColor = .clear
                configuration.userContentController.addUserScript(.init(source: Dark.script, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
            }
            
            if ads {
                configuration.userContentController.blockAds()
            }
            
            if cookies {
                configuration.userContentController.blockCookies()
            }
            
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
                        guard var name = self?.view.session.page?.url.lastPathComponent.replacingOccurrences(of: "/", with: "") else { return }
                        if name.isEmpty {
                            name = "Page.pdf"
                        } else if !name.hasSuffix(".pdf") {
                            name = name.components(separatedBy: ".").dropLast().joined(separator: ".") + ".pdf"
                        }
                        UIApplication.shared.share(data.temporal(name))
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
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            print(message)
            completionHandler()
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            view.session.state.error = nil
        }
        
        func webView(_: WKWebView, didFinish: WKNavigation!) {
            view.session.state.progress = 1
//            let jsString = """
//var style = document.createElement('style');
//style.innerHTML = ':root, img { filter: invert(1)  hue-rotate(.5turn); }';
//document.head.appendChild(style);
//"""
//            evaluateJavaScript(jsString) {
//                print("js \($0), err \($1)")
//            }
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
                    print("allow \(decidePolicyFor.request.url!)")
                    preferences.allowsContentJavaScript = self?.javascript ?? false
                    decisionHandler(.allow, preferences)
                case .external:
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
    }
}
