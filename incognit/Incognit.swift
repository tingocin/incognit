import SwiftUI
import Combine

@main struct Incognit: App {
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all)
                if session.current == nil {
                    Book(session: $session)
                } else {
                    Tab(session: $session)
                }
            }.onAppear {
                assert(session.pages.isEmpty)
                var sub: AnyCancellable?
                sub = session.balam.nodes(Page.self).sink {
                    session.pages = .init($0)
                    sub = session.balam.nodes(Engine.self).sink {
                        $0.first.map {
                            session.engine = $0
                        }
                        sub?.cancel()
                    }
                }
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
