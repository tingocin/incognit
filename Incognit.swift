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
                pages()
                UIApplication.shared.appearance()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if let created = User.created {
                        if !User.rated && Calendar.current.component(.day, from: created) > 10 {
                            User.rated = true
                            UIApplication.shared.rate()
                        }
                    } else {
                        User.created = .init()
                    }
                }
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
            url.absoluteString.replacingOccurrences(of: "incognit://", with: "").removingPercentEncoding.map {
                session.browse($0)
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
                    guard var pages = session.pages.value else { return }
                    pages.remove(page)
                    pages.insert(page)
                    session.pages.value = pages
                }
            }
        case "incognit-search":
            session.type.send()
        default:
            session.browse(url)
        }
    }
}
