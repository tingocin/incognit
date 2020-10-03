import Foundation

struct User: Codable {
    var premium = false
    var rated = false
    var popups = true
    var javascript = true
    var ads = true
    var engine = Engine.ecosia
    let created: Date
    
    init() {
        created = .init()
    }
}
