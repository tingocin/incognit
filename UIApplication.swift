import UIKit

extension UIApplication {
    func appearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
    }
    
    func share(_ any: Any) {
        let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = windows.first?.rootViewController?.presentedViewController?.view
        windows.first?.rootViewController?.presentedViewController?.present(controller, animated: true)
    }
}
