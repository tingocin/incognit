import SwiftUI

@main struct Incognit: App {
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
