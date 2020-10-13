import Foundation
import WatchConnectivity

final class Delegate: NSObject, WCSessionDelegate {
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) {
        guard WCSession.isSupported() && WCSession.default.isPaired && WCSession.default.isWatchAppInstalled else { return }
//        WCSession.default.sendMessage(basic, replyHandler: nil, errorHandler: nil)
    }
    
    func sessionDidBecomeInactive(_: WCSession) {
        
    }
    
    func sessionDidDeactivate(_: WCSession) {
        
    }
}
