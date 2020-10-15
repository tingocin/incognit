import Foundation

extension Session {
    struct State {
        var error: String?
        var forwards = false
        var backwards = false
        var progress = Double()
        var blocked = [URL]()
    }
}