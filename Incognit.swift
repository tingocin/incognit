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
                Tab(session: $session)
                    .onOpenURL(perform: open)
            }
        }.onChange(of: phase) {
            if $0 == .active {
                guard session.user == nil else { return }
                UIApplication.shared.appearance()
                load()
            }
        }
    }
    
    private func open(_ url: URL) {
        UIApplication.shared.dismiss()
        switch url.scheme {
        case "incognit":
            load()
            session.dispatch.async {
                url.absoluteString.replacingOccurrences(of: "incognit://", with: "").removingPercentEncoding.map {
                    session.browse($0)
                }
            }
        default:
            session.browse(url)
        }
    }
    
    private func load() {
        session.dispatch.async {
            guard session.user == nil else { return }
            if let user = FileManager.default.user {
                session.user = user
            } else {
                let user = User()
                session.user = user
                session.save(user)
            }
        }
    }
}
