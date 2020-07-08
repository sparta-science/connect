import Foundation

class BundleHelper {
    let fileHelper = FileHelper()
    let bundleId: String
    init(bundleId: String = "com.spartascience.SpartaConnect") {
        self.bundleId = bundleId
    }
    func find(file fileName: String, inCache subpath: String) -> NSPredicate {
        fileHelper.find(file: fileName, at: cacheUrl().appendingPathComponent(subpath))
    }

    func eraseInstallation() {
        fileHelper.remove(url: appSupportURL())
    }

    func findInstalled(file: String) -> NSPredicate {
        fileHelper.find(file: file, at: appSupportURL())
    }

    private func cacheUrl() -> URL {
        fileHelper.fileUrl(path: bundleId, in: .cachesDirectory)
    }

    private func appSupportURL() -> URL {
        fileHelper.fileUrl(path: bundleId, in: .applicationSupportDirectory)
    }

    func clearCache() {
        fileHelper.clearSubfolders(cacheUrl())
    }

    private func defaults() -> UserDefaults {
        UserDefaults(suiteName: bundleId)!
    }

    func persistDefaults(_ values: [String: Any]) {
        let bundleDefaults = defaults()
        bundleDefaults.setPersistentDomain(values, forName: bundleId)
        bundleDefaults.synchronize()
    }

    func clearDefaults() {
        defaults().removePersistentDomain(forName: bundleId)
    }
}
