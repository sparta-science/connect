import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let bundleHelper = BundleHelper(bundleId: "com.spartascience.SpartaConnect")
    func tempApp() -> XCUIApplication {
        XCUIApplication(url: tempUrl)
    }
    
    func clearCache() {
        bundleHelper.clearCache()
    }
    
    func hasDownloaded(fileName: String) -> NSPredicate {
        bundleHelper.exists(inCache: "org.sparkle-project.Sparkle/PersistentDownloads",
                          file: fileName)
    }
    
    func prepare() {
        cleanup()
        let builtApp = XCUIApplication()
        let builtAppPath = builtApp.value(forKeyPath: "_applicationImpl._path") as! String
        bundleHelper.copy(path: builtAppPath, to: tempUrl)
    }
    func cleanup() {
        bundleHelper.remove(url: tempUrl)
    }
}

class MoveAppHelper: TempAppHelper {
    let movedUrl = URL(fileURLWithPath: "/Applications/SpartaConnect.app")
    func movedApp() -> XCUIApplication {
        XCUIApplication(url: movedUrl)
    }
    override func cleanup() {
        super.cleanup()
        bundleHelper.remove(url: movedUrl)
    }
}
