import XCTest

class FileHelper {
    let fileManager = FileManager.default

    func remove(url: URL, file: StaticString = #file, line: UInt = #line) {
        try? fileManager.removeItem(at: url)
        XCTAssertFalse(fileManager.fileExists(atPath: url.path),
                       "should be removed", file: file, line: line)
    }
    
    func copy(path: String, to destination: URL) {
        try! fileManager.copyItem(at: URL(fileURLWithPath: path), to: destination)
        XCTAssertTrue(fileManager.fileExists(atPath: destination.path))
    }
    
    func exists(inCache: String, forBundle bundleId: String, file withName: String) -> NSPredicate {
        let bundleCache = cacheUrl(bundleId: bundleId)
        let downloads = bundleCache.appendingPathComponent(inCache)
        return NSPredicate { object, variables  in
            let list = self.fileManager.enumerator(at: downloads,
                                              includingPropertiesForKeys: [.isDirectoryKey])!
            for case let fileURL as URL in list {
                if fileURL.lastPathComponent == withName {
                    NSLog(fileURL.lastPathComponent)
                    return true
                }
            }
            return false
        }
    }

    func cacheUrl(bundleId: String) -> URL {
        let userCache = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return userCache.appendingPathComponent(bundleId)
    }
    
    func removeCache(bundleId: String) {
        let bundleCache = cacheUrl(bundleId: bundleId)
        let subfolders = fileManager.enumerator(at: bundleCache, includingPropertiesForKeys: nil)!
        for case let fileURL as URL in subfolders {
            try? fileManager.removeItem(at: fileURL)
        }
    }
}
