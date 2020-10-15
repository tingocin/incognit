import WatchConnectivity

extension Shared {
    static func chart(_ pages: Set<Page>) {
        if pages.isEmpty {
            since = .init()
            chart = []
        } else {
            let dates = pages.map(\.date.timeIntervalSince1970)
            let initial = dates.min()!
            let interval = (Date().timeIntervalSince1970 - initial) / 5
            let ranges = (0 ..< 5).map {
                (.init($0) * interval) + initial
            }
            let array = dates.reduce(into: Array(repeating: Double(), count: 5)) {
                var index = 0
                while index < 4 && ranges[index + 1] < $1 {
                    index += 1
                }
                $0[index] += 1
            }
            chart = array.map { $0 / array.max()! }
            since = .init(timeIntervalSince1970: initial)
        }

        if WCSession.isSupported() && WCSession.default.activationState == .activated && WCSession.default.isPaired && WCSession.default.isWatchAppInstalled {
            try? WCSession.default.updateApplicationContext([Shared.Key.chart.rawValue : chart, Shared.Key.since.rawValue : since])
        }
    }
}
