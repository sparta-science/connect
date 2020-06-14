import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let bundleHelper = BundleHelper(bundleId: "com.spartascience.SpartaConnect")
    let fileHelper = FileHelper()
    var removeMonitor: (()->Void)!
    func tempApp() -> XCUIApplication {
        let url = LSCopyDefaultApplicationURLForURL(tempUrl as CFURL, .all, nil)
        XCTAssertEqual(url?.takeRetainedValue() as URL?, tempUrl)
        return XCUIApplication(url: tempUrl)
    }
    
    func clearCache() {
        bundleHelper.clearCache()
    }
    
    func hasDownloaded(fileName: String) -> NSPredicate {
        bundleHelper.find(file: fileName,
                          inCache: "org.sparkle-project.Sparkle/PersistentDownloads")
    }
    
    func prepare(for test: XCTestCase) {
        let openFirstTimeMonitor = test.addUIInterruptionMonitor(
            withDescription: "open first time"
        ) { alert -> Bool in
            print(alert)
            if alert.buttons["Show Application"].exists {
                XCTAssertTrue(alert.staticTexts[
                    "You are opening the application “SpartaConnect” for the first time. "
                        + "Are you sure you want to open this application?"
                ].exists)
                alert.buttons["Open"].click()
                return true
            }
            return false
        }
        removeMonitor = {test.removeUIInterruptionMonitor(openFirstTimeMonitor)}
        removeTempApp()
        fileHelper.copy(XCUIApplication().url, to: tempUrl)
    }
    private func removeTempApp() {
        fileHelper.remove(url: tempUrl)
    }
    func cleanup() {
        removeMonitor()
        removeMonitor = nil
        removeTempApp()
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
