import UIKit
import StoreKit
import WebKit

extension UIApplication {
    func appearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
    }
    
    func resign() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func share(_ any: Any) {
        let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = windows.first?.rootViewController?.presentedViewController?.view
        windows.first?.rootViewController?.presentedViewController?.present(controller, animated: true)
    }
    
    func rate() {
        windows.first.flatMap(\.windowScene).map(SKStoreReviewController.requestReview(in:))
    }
    
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func forget() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
    }
}
