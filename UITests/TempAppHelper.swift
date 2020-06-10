import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let bundleHelper = BundleHelper(bundleId: "com.spartascience.SpartaConnect")
    let fileHelper = FileHelper()
    func tempApp() -> XCUIApplication {
        XCUIApplication(url: tempUrl)
    }
    
    func clearCache() {
        bundleHelper.clearCache()
    }
    
    func hasDownloaded(fileName: String) -> NSPredicate {
        bundleHelper.find(file: fileName,
                          inCache: "org.sparkle-project.Sparkle/PersistentDownloads")
    }
    
    func prepare() {
        cleanup()
        fileHelper.copy(XCUIApplication().url, to: tempUrl)
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
