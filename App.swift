import SwiftUI
import WatchConnectivity
import StoreKit

@main struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    @State private var session = Session()
    private let sessionDelegate = SessionDelegate()
    
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
            .onReceive(sessionDelegate.forget) {
                session.dismiss.send()
                session.forget()
                UIApplication.shared.forget()
            }
        }.onChange(of: phase) {
            if $0 == .active {
                if session.page == nil {
                    pages()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let created = User.created {
                        if !User.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                            User.rated = true
                            SKStoreReviewController.requestReview(in: UIApplication.shared.windows.first!.windowScene!)
                        }
                    } else {
                        User.created = .init()
                    }
                }
                
                if WCSession.isSupported() && WCSession.default.activationState != .activated {
                    WCSession.default.delegate = sessionDelegate
                    WCSession.default.activate()
                }
            }
        }.onChange(of: session.page) {
            if $0 == nil {
                pages()
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
            session.resign.send()
            url.absoluteString.replacingOccurrences(of: "incognit://", with: "").removingPercentEncoding.map {
                session.browse($0)
            }
        case "incognit-id":
            session.resign.send()
            session.browse(id: url.absoluteString.replacingOccurrences(of: "incognit-id://", with: ""))
        case "incognit-search":
            session.type.send(nil)
        default:
            session.resign.send()
            session.browse(url)
        }
    }
}
