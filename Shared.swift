import Foundation

struct Shared {
    private static let defaults = UserDefaults(suiteName: "group.incognit.share")!
    
    static var history: Data? {
        get { get(.history) as? Data }
        set { set(newValue, key: .history) }
    }
    
    static var chart: [Double] {
        get { get(.chart) as? [Double] ?? [] }
        set { set(newValue, key: .chart) }
    }
    
    static var since: Date {
        get { get(.since) as? Date ?? .init() }
        set { set(newValue, key: .since) }
    }
    
    private static func set(_ value: Any?, key: Key) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    private static func get(_ key: Key) -> Any? {
        defaults.object(forKey: key.rawValue)
    }
}
