import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let fileHelper = FileHelper()
    func tempApp() -> XCUIApplication {
        XCUIApplication(url: tempUrl)
    }
    
    let bundleId = "com.spartascience.SpartaConnect"
    
    func clearCache() {
        fileHelper.removeCache(bundleId: bundleId)
    }
    
    func hasDownloaded(fileName: String) -> NSPredicate {
        fileHelper.exists(inCache: "org.sparkle-project.Sparkle/PersistentDownloads",
                          forBundle: bundleId,
                          file: fileName)
    }
    
    func persistDefaults(_ values: [String: Any])  {
        let defaults = bundleDefaults()
        defaults.setPersistentDomain(values, forName: bundleId)
        defaults.synchronize()
    }
    
    func bundleDefaults() -> UserDefaults {
        UserDefaults(suiteName: bundleId)!
    }
    
    func clearDefaults() {
        bundleDefaults().removePersistentDomain(forName: bundleId)
    }
    
    func prepare() {
        cleanup()
        let builtApp = XCUIApplication()
        let builtAppPath = builtApp.value(forKeyPath: "_applicationImpl._path") as! String
        fileHelper.copy(path: builtAppPath, to: tempUrl)
    }
    func cleanup() {
        fileHelper.remove(url: tempUrl)
    }
}

class MoveAppHelper: TempAppHelper {
    let movedUrl = URL(fileURLWithPath: "/Applications/SpartaConnect.app")
    func movedApp() -> XCUIApplication {
        XCUIApplication(url: movedUrl)
    }
    override func cleanup() {
        super.cleanup()
        fileHelper.remove(url: movedUrl)
    }
}
