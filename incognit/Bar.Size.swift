import SwiftUI

extension Bar {
    enum Size: CGFloat {
        case
        hidden = 0,
        small = 90,
        full = 150
        
        var title: LocalizedStringKey {
            switch self {
            case .full: return "Browse"
            default: return ""
            }
        }
        
        var image: Bool {
            switch self {
            case .small: return true
            default: return false
            }
        }
        
        var background: Bool {
            switch self {
            case .hidden: return false
            default: return true
            }
        }
    }
}
