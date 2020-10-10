import Foundation

final class User: UserDefaults {
    private static let _premium = "incognit_premium"
    private static let _rated = "incognit_rated"
    private static let _popups = "incognit_popups"
    private static let _javascript = "incognit_javascript"
    private static let _ads = "incognit_ads"
    private static let _secure = "incognit_secure"
    private static let _trackers = "incognit_trackers"
    private static let _cookies = "incognit_cookies"
    private static let _engine = "incognit_engine"
    private static let _created = "incognit_created"
    
    class var premium: Bool {
        get { standard.object(forKey: _premium) as? Bool ?? false }
        set { standard.setValue(newValue, forKey: _premium) }
    }
    
    class var rated: Bool {
        get { standard.object(forKey: _rated) as? Bool ?? false }
        set { standard.setValue(newValue, forKey: _rated) }
    }
    
    class var popups: Bool {
        get { standard.object(forKey: _popups) as? Bool ?? true }
        set { standard.setValue(newValue, forKey: _popups) }
    }
    
    class var javascript: Bool {
        get { standard.object(forKey: _javascript) as? Bool ?? true }
        set { standard.setValue(newValue, forKey: _javascript) }
    }
    
    class var ads: Bool {
        get { standard.object(forKey: _ads) as? Bool ?? true }
        set { standard.setValue(newValue, forKey: _ads) }
    }
    
    class var trackers: Bool {
        get { standard.object(forKey: _trackers) as? Bool ?? true }
        set { standard.setValue(newValue, forKey: _trackers) }
    }
    
    class var cookies: Bool {
        get { standard.object(forKey: _cookies) as? Bool ?? true }
        set { standard.setValue(newValue, forKey: _cookies) }
    }
    
    class var secure: Bool {
        get { standard.object(forKey: _secure) as? Bool ?? true }
        set { standard.setValue(newValue, forKey: _secure) }
    }
    
    class var engine: Engine {
        get { (standard.object(forKey: _engine) as? String).flatMap(Engine.init(rawValue:)) ?? .ecosia }
        set { standard.setValue(newValue.rawValue, forKey: _engine) }
    }
    
    class var created: Date? {
        get { standard.object(forKey: _created) as? Date }
        set { standard.setValue(newValue, forKey: _created) }
    }
}
