import Foundation
import WatchConnectivity
import CoreGraphics

final class Delegate: NSObject, ObservableObject, WCSessionDelegate {
    @Published private(set) var chart = [CGFloat]()
    @Published private(set) var first = ""
    
    func session(_ a: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) {
        print(a.applicationContext)
    }

    func session(_: WCSession, didReceiveApplicationContext: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            print(didReceiveApplicationContext)
            (didReceiveApplicationContext["chart"] as? [CGFloat]).map {
                self?.chart = $0
            }
            (didReceiveApplicationContext["first"] as? String).map {
                self?.first = $0
                print($0)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("message")
        print(message)
    }
}
