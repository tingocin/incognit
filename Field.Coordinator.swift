import SwiftUI
import Combine

extension Field {
    final class Coordinator: UISearchBar, UISearchBarDelegate {
        private var subs = Set<AnyCancellable>()
        private let view: Field
        
        required init?(coder: NSCoder) { nil }
        init(view: Field) {
            self.view = view
            super.init(frame: .zero)
            searchBarStyle = .minimal
            autocapitalizationType = .none
            autocorrectionType = .no
            enablesReturnKeyAutomatically = false
            barTintColor = UIColor(named: "AccentColor")!
            tintColor = UIColor(named: "AccentColor")!
            keyboardType = .webSearch
            searchTextField.allowsEditingTextAttributes = false
            searchTextField.clearButtonMode = .never
            searchTextField.leftView = nil
            searchTextField.rightView = nil
            searchTextField.borderStyle = .none
            searchTextField.textAlignment = .center
            delegate = self
            
            view.session.dismiss.sink { [weak self] in
                self?.resignFirstResponder()
            }.store(in: &subs)
            
            view.session.type.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
        }
        
        func searchBarTextDidBeginEditing(_: UISearchBar) {
            view.session.typing = true
        }
        
        func searchBarTextDidEndEditing(_: UISearchBar) {
            view.session.typing = false
        }
        
        func searchBarSearchButtonClicked(_: UISearchBar) {
            text.map {
                view.session.browse($0)
            }
            text = nil
            resignFirstResponder()
        }
    }
}
