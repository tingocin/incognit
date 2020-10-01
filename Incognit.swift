import SwiftUI

@main struct Incognit: App {
    @State private var session = Session()
    @State private var _user = false
    @State private var _pages = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
                if session.page == nil {
                    Book(session: $session)
                        .onAppear(perform: pages)
                }
                if session.page != nil {
                    Tab(session: $session)
                }
            }
            .onOpenURL(perform: open)
            .onAppear(perform: launch)
        }
    }
    
    private func launch() {
        NSLog("incognit:::: launch")
        guard !_user else { return }
        _user = true
        session.dispatch.async {
            if let user = FileManager.default.user {
                session.user = user
            } else {
                let user = User()
                session.user = user
                session.save(user)
            }
            NSLog("incognit:::: user ready")
        }
        UIApplication.shared.appearance()
    }
    
    private func pages() {
        NSLog("incognit:::: pages")
        guard !_pages else { return }
        _pages = true
        session.dispatch.async {
            session.pages.value = FileManager.default.pages
            NSLog("incognit:::: pages ready")
        }
    }
    
    
    
    
    
    
    
    
    
    private func open(_ url: URL) {
        NSLog("incognit:::: open")
        session.dismiss.send()
        
        switch url.scheme {
        case "incognit":
            session.dispatch.async {
                url.absoluteString.replacingOccurrences(of: "incognit://", with: "").removingPercentEncoding.map {
                    session.browse($0)
                }
            }
        case "incognit-id":
            let id = url.absoluteString.replacingOccurrences(of: "incognit-id://", with: "")
            (session.pages.value.first { $0.id.uuidString == id } ?? FileManager.default.load(id)).map {
                $0.date = .init()
                if session.page == nil {
                    session.page = $0
                } else {
                    session.page = $0
                    session.navigate.send($0.url)
                }
                session.save.send($0)
                NSLog("incognit:::: page ready")
            }
        case "incognit-search":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                session.type.send()
            }
        default:
            session.browse(url)
        }
    }
}
