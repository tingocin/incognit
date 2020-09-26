import SwiftUI
import Combine

@main struct Incognit: App {
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            if session.current == nil {
                Book(session: $session)
                    .onOpenURL(perform: open)
            } else {
                Tab(session: $session)
                    .onOpenURL(perform: open)
            }
        }.onChange(of: phase) {
            if $0 == .active {
                UIApplication.shared.windows.first?.rootViewController?.view.backgroundColor = .secondarySystemBackground
                
                if session.pages.isEmpty {
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
    
    private func open(_ url: URL) {
        if session.current != nil {
            session.current = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var url = url
            if url.scheme == "incognit" {
                URL(string: url.absoluteString.replacingOccurrences(of: "incognit://", with: "http://")).map {
                    url = $0
                }
            }
            let page = Page(url: url)
            session.add(page)
            session.current = page
        }
    }
}

private final class Delegate: NSObject, UIApplicationDelegate {
    func application(_ a: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
        return true
    }
}
