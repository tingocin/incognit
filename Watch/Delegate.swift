import Foundation
import WatchConnectivity

final class Delegate: NSObject, ObservableObject, WCSessionDelegate {
    @Published private(set) var chart = Shared.chart
    private(set) var since = Shared.since
    
    func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) { }

    func session(_: WCSession, didReceiveApplicationContext: [String: Any]) {
        Shared.chart = didReceiveApplicationContext[Shared.Key.chart.rawValue] as? [Double] ?? []
        Shared.since = didReceiveApplicationContext[Shared.Key.since.rawValue] as? Date ?? .init()
        DispatchQueue.main.async { [weak self] in
            self?.chart = Shared.chart
            self?.since = Shared.since
        }
    }
    
    func forget() {
        guard WCSession.isSupported() && WCSession.default.activationState == .activated && WCSession.default.isReachable && WCSession.default.isCompanionAppInstalled else { return }
        WCSession.default.sendMessage([Shared.Key.forget.rawValue : true], replyHandler: nil, errorHandler: nil)
        Shared.since = .init()
        Shared.chart = []
        since = Shared.since
        chart = Shared.chart
    }
}
