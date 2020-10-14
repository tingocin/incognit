import Foundation

struct Shared {
    private static let defaults = UserDefaults(suiteName: "group.incognit.share")!
    
    static func set(_ value: Any?, key: Key) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    static func get(_ key: Key) -> Any? {
        defaults.object(forKey: key.rawValue)
    }
}
