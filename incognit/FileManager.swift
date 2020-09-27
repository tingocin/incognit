import Foundation

extension FileManager {
    static var pages: Set<Page> {
        guard FileManager.default.fileExists(atPath: _pages.path) else { return [] }
        return .init((try? FileManager.default.contentsOfDirectory(at: _pages, includingPropertiesForKeys: [], options: .skipsHiddenFiles)).map {
            $0.compactMap {
                try? JSONDecoder().decode(Page.self, from: Data(contentsOf: $0))
            }
        } ?? [])
    }
    
    static var user: User? {
        nil
    }
    
    private static let root = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private static let _pages = root.appendingPathComponent("pages")
    private static let _user = root.appendingPathComponent("user")
}
