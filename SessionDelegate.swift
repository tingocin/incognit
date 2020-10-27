import Foundation
import WatchConnectivity
import Combine

final class SessionDelegate: NSObject, WCSessionDelegate {
    let forget = PassthroughSubject<Void, Never>()
    
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) { }
    func sessionDidBecomeInactive(_: WCSession) { }
    func sessionDidDeactivate(_: WCSession) { }
    
    func session(_: WCSession, didReceiveMessage: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            didReceiveMessage[Shared.Key.forget.rawValue].flatMap { $0 as? Bool }.map {
                guard $0 else { return }
                self?.forget.send()
            }
        }
    }
}
