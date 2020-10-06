import Foundation

enum Engine: String {
    case
    ecosia,
    google
    
    var prefix: String {
        switch self {
        case .ecosia: return "https://www.ecosia.org/search?q="
        case .google: return "https://google.com/search?q="
        }
    }
}
