import Foundation

struct User: Codable {
    var premium = false
    var rated = false
    var popups = false
    var javascript = true
    var ads = false
    var secure = true
    var engine = Engine.ecosia
    let created: Date
    
    init() {
        created = .init()
    }
}
