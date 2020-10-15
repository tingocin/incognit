import SwiftUI
import WatchConnectivity

@main struct Incognit: App {
    private let delegate = Delegate()
    
    var body: some Scene {
        WindowGroup {
            Usage(delegate: delegate)
                .onAppear {
                    if WCSession.default.activationState != .activated {
                        WCSession.default.delegate = delegate
                        WCSession.default.activate()
                    }
                }
        }
    }
}
