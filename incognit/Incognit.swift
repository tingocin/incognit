import SwiftUI

@main struct Incognit: App {
    @Environment(\.scenePhase) private var phase
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            if session.page == nil {
                Book(session: $session)
                    .onOpenURL(perform: open)
            } else {
//                Tab(session: delegate.$session)
//                    .onOpenURL(perform: open)
            }
        }.onChange(of: phase) {
            if $0 == .active {
                guard session.user == nil else { return }
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "AccentColor")!
                UIApplication.shared.windows.first?.rootViewController?.view.backgroundColor = .secondarySystemBackground
                session.dispatch.async {
                    session.user = FileManager.user ?? .init()
                }
            }
        }
    }
    
    private func open(_ url: URL) {
//        if session.page != nil {
//            session.page = nil
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            var url = url
//            if url.scheme == "incognit" {
//                URL(string: url.absoluteString.replacingOccurrences(of: "incognit://", with: "http://")).map {
//                    url = $0
//                }
//            }
//            let page = Page(url: url)
//            session.add(page)
//            session.page = page
//        }
    }
}
