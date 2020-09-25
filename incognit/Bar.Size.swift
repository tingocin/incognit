import SwiftUI

extension Bar {
    enum Size: CGFloat {
        case
        hidden = 0,
        small = 80,
        full = 150
        
        var title: LocalizedStringKey {
            switch self {
            case .full: return "Search or website"
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
