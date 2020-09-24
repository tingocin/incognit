import SwiftUI

@main struct Incognit: App {
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            if session.page == nil {
                Book(session: $session)
            } else {
                Tab(session: $session)
            }
        }
    }
}

private final class Delegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
        return true
    }
}
