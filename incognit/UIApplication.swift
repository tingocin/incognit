import UIKit
import WebKit

extension UIApplication {
    var textField: UITextField? {
        windows.first?.rootViewController?.view.textField
    }
    
    func resign() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func appearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
        windows.forEach {
            $0.rootViewController?.view.backgroundColor = .secondarySystemBackground
        }
    }
    
    func forget() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
    }
}

private extension UIView {
    var textField: UITextField? {
        subviews.compactMap { $0 as? UITextField }.first ??
            subviews.compactMap { $0.textField }.first
    }
}
