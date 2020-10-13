import Foundation
import WatchConnectivity
import CoreGraphics

final class Delegate: NSObject, ObservableObject, WCSessionDelegate {
    @Published private(set) var chart = [CGFloat]()
    @Published private(set) var first = ""
    
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) { }

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
}
