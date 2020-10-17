import Foundation

extension Data {
    func temporal(_ name: String) -> URL {
        {
            try? write(to: $0, options: .atomic)
            return $0
        } (URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name))
    }
}
