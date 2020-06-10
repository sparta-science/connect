import Foundation

class BundleHelper: FileHelper {
    let bundleId: String
    init(bundleId: String) {
        self.bundleId = bundleId
    }
    func exists(inCache subpath: String,
                file fileName: String) -> NSPredicate {
        let url = cacheUrl().appendingPathComponent(subpath)
        return NSPredicate { _, _  in
            let list = self.fileManager.enumerator(at: url,
                                                   includingPropertiesForKeys: nil)!
            return list.contains { ($0 as? URL)?.lastPathComponent == fileName }
        }
    }
    
    private func cacheUrl() -> URL {
        fileUrl(path: bundleId, in: .cachesDirectory)
    }
    
    func clearCache() {
        clearSubfolders(cacheUrl())
    }
    
    private func defaults() -> UserDefaults {
        UserDefaults(suiteName: bundleId)!
    }
    
    func persistDefaults(_ values: [String: Any])  {
        let bundleDefaults = defaults()
        bundleDefaults.setPersistentDomain(values, forName: bundleId)
        bundleDefaults.synchronize()
    }
    
    func clearDefaults() {
        defaults().removePersistentDomain(forName: bundleId)
    }

}
