import SwiftUI

@main struct Incognit: App {
    @Environment(\.scenePhase) private var phase
    @State private var session = Session()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if session.page == nil {
                    Book(session: $session)
                } else {
                    Tab(session: $session)
                }
                Tools(session: $session)
            }
            .background(Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all))
            .onOpenURL(perform: open)
        }.onChange(of: phase) {
            if $0 == .active {
                launch()
                pages()
                UIApplication.shared.appearance()
                
                session.dispatch.async {
                    if !session.user!.rated && Calendar.current.component(.day, from: session.user!.created) > 10 {
                        session.user!.rated = true
                        DispatchQueue.main.async {
                            UIApplication.shared.rate()
                        }
                    }
                }
            }
        }
    }
    
    private func launch() {
        guard session.user == nil else { return }
        session.dispatch.async {
            guard session.user == nil else { return }
            if let user = FileManager.default.user {
                session.user = user
            } else {
                session.user = User()
            }
        }
    }
    
    private func pages() {
        guard session.pages.value == nil else { return }
        session.dispatch.async {
            session.pages.value = FileManager.default.pages
        }
    }
    
    private func open(_ url: URL) {
        session.dismiss.send()
        
        switch url.scheme {
        case "incognit":
            launch()
            session.dispatch.async {
                url.absoluteString.replacingOccurrences(of: "incognit://", with: "").removingPercentEncoding.map {
                    session.browse($0)
                }
            }
        case "incognit-id":
            let id = url.absoluteString.replacingOccurrences(of: "incognit-id://", with: "")
            (session.pages.value?.first { $0.id.uuidString == id } ?? FileManager.default.load(id)).map { page in
                page.date = .init()
                if session.page == nil {
                    session.page = page
                } else {
                    session.page = page
                    session.navigate.send(page.url)
                }
                session.save.send(page)
                session.dispatch.asyncAfter(deadline: .now() + 1) {
                    session.pages.value?.remove(page)
                    session.pages.value?.insert(page)
                }
            }
        case "incognit-search":
            session.type.send()
        default:
            session.browse(url)
        }
    }
}
