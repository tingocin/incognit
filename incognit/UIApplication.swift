import UIKit

extension UIApplication {
    var textField: UITextField {
        windows.first!.rootViewController!.view.textField!
    }
}

private extension UIView {
    var textField: UITextField? {
        subviews.compactMap { $0 as? UITextField }.first ??
            subviews.compactMap { $0.textField }.first
    }
}
