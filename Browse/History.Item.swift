import Foundation

extension History {
    struct Item: Codable {
        let open: URL?
        let url: URL?
        let title: String
    }
}
