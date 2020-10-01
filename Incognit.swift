import SwiftUI

@main struct Incognit: App {
    @Environment(\.scenePhase) private var phase
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if session.page == nil {
                    Book(session: $session)
                }
                if session.page != nil {
                    Tab(session: $session)
                }
            }
            .onAppear(perform: pages)
            .onOpenURL(perform: open)
        }.onChange(of: phase) {
            if $0 == .active {
                guard session.user == nil else { return }
                UIApplication.shared.appearance()
                load()
            }
        }
    }
    
    private func open(_ url: URL) {
        session.dismiss.send()
        
        switch url.scheme {
        case "incognit":
            load()
            session.dispatch.async {
                url.absoluteString.replacingOccurrences(of: "incognit://", with: "").removingPercentEncoding.map {
                    session.browse($0)
                }
            }
        case "incognit-id":
            if session.pages.value.isEmpty {
                pages()
                session.dispatch.async {
                    DispatchQueue.main.async {
                        open(url.absoluteString)
                    }
                }
            } else {
                open(url.absoluteString)
            }
        case "incognit-search":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                session.type.send()
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
    
    private func pages() {
        guard session.pages.value.isEmpty else { return }
        session.dispatch.async {
            let pages = FileManager.default.pages
            DispatchQueue.main.async {
                session.pages.value = pages
            }
        }
    }
    
    private func open(_ id: String) {
        session.pages.value.first { $0.id.uuidString == id.replacingOccurrences(of: "incognit-id://", with: "") }.map {
            $0.date = .init()
            if session.page != nil {
                session.page = $0
                session.navigate.send($0.url)
            } else {
                session.page = $0
            }
            session.save.send($0)
        }
    }
}
