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
        controller.popoverPresentationController?.sourceView = windows.first!.rootViewController!.presentedViewController?.view
        windows.first!.rootViewController!.presentedViewController?.present(controller, animated: true)
    }
    
    func rate() {
        SKStoreReviewController.requestReview(in: windows.first!.windowScene!)
    }
    
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func forget() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
            $0.forEach {
                WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) { }
            }
        }
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
    }
}
