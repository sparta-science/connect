import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect-\(arc4random()).app")
    let bundleHelper = BundleHelper(bundleId: "com.spartascience.SpartaConnect")
    let fileHelper = FileHelper()
    var removeMonitor: (()->Void)!
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

    func launch(arguments:[String] = []) {
        let workspace = NSWorkspace.shared
        let config = NSWorkspace.OpenConfiguration()
        config.arguments = arguments
        let running = XCTestExpectation(description: "running")
        running.assertForOverFulfill = true
        workspace.open(tempUrl, configuration: config) { app, err in
            running.fulfill()
            XCTAssertNil(err)
        }
        XCTWaiter.wait(until: running, "should be running")
    }
    
    func prepare(for test: XCTestCase) {
        let openFirstTimeMonitor = test.addUIInterruptionMonitor(
            withDescription: "open first time"
        ) { alert -> Bool in
            if alert.buttons["Show Application"].exists {
                NSLog("alert: " + alert.debugDescription)
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
        let original = XCUIApplication().url
        NSLog("original app: \(original)")
        fileHelper.copy(original, to: tempUrl)
//        LaunchService.waitForAppToBeReadyForLaunch(at: tempUrl)
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
    lazy var movedUrl = fileHelper
        .preferredApplicationsUrl()
        .appendingPathComponent(tempUrl.lastPathComponent)

    func movedApp() -> XCUIApplication {
        XCUIApplication(url: movedUrl)
    }
    override func cleanup() {
        super.cleanup()
        fileHelper.remove(url: movedUrl)
    }
}
