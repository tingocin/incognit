import Foundation

struct User: Codable {
    var premium = false
    var rated = false
    var engine = Engine.ecosia
    let created: Date
    
    init() {
        created = .init()
    }
}
