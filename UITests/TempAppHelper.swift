import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect-\(arc4random()).app")
    let bundleHelper = BundleHelper(bundleId: "com.spartascience.SpartaConnect")
    let fileHelper = FileHelper()
    var removeMonitor: (()->Void)!
    let workspaceHelper = WorkspaceHelper()
    func tempApp() -> XCUIApplication {
        XCUIApplication(url: tempUrl)
    }
    
    func clearCache() {
        bundleHelper.clearCache()
    }

    func syncFileSystem() {
        fileHelper.syncFileSystem(for: tempUrl)
    }
    
    func hasDownloaded(fileName: String) -> NSPredicate {
        bundleHelper.find(file: fileName,
                          inCache: "org.sparkle-project.Sparkle/PersistentDownloads")
    }

    func launch(arguments: [String] = []) {
        workspaceHelper.launch(url: tempUrl,
                               arguments: arguments)
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
