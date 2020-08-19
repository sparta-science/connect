import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnectForUITest.app")
    let bundleHelper = BundleHelper()
    let fileHelper = FileHelper()
    var removeMonitor: (() -> Void)!
    let workspaceHelper = WorkspaceHelper()
    func tempApp() -> SpartaConnectApp {
        SpartaConnectApp(url: tempUrl)
    }

    func clearCache() {
        bundleHelper.clearCache()
    }

    func syncFileSystem() {
        fileHelper.syncFileSystem(for: tempUrl)
    }

    func verifyAppRegistedToLaunch() {
        workspaceHelper.verifyAppRegistedToLaunch(url: tempUrl)
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
        ) { dialog -> Bool in
            if dialog.label == "alert", dialog.buttons["Show Application"].exists {
                NSLog("alert: " + dialog.debugDescription)
                XCTAssertTrue(dialog.staticTexts[
                    "You are opening the application “SpartaConnectForUITest” for the first time. "
                        + "Are you sure you want to open this application?"
                ].exists)
                dialog.buttons["Open"].click()
                RareEventMonitor.log(.firstTimeOpenAlert)
                return true
            }
            return false
        }
        removeMonitor = { test.removeUIInterruptionMonitor(openFirstTimeMonitor) }
        removeTempApp()
        let original = XCUIApplication().url
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
