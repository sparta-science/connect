import XCTest

class TempAppHelper {
    let appNameForTesting = "SpartaConnectForUITest"
    lazy var tempUrl = URL(fileURLWithPath: "/tmp/\(appNameForTesting).app")
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

    func waitForAppToLaunchDismissingFirstTimeOpenAlerts(app: XCUIApplication,
                                                         location: (StaticString, UInt) = (#file, #line)) {
        let agent = XCUIApplication(bundleIdentifier: "com.apple.coreservices.uiagent")
        repeat {
            if agent.dialogs.count > 0 {
                handleFistTimeOpenAlert(dialog: agent.dialogs.firstMatch)
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
        } while app.state == .notRunning
        app.activate()
    }

    func hasDownloaded(fileName: String) -> NSPredicate {
        bundleHelper.find(file: fileName,
                          inCache: "org.sparkle-project.Sparkle/PersistentDownloads")
    }

    func launch(arguments: [String] = []) {
        workspaceHelper.launch(url: tempUrl,
                               arguments: arguments)
        tempApp().wait(until: .runningForeground, "should be launched")
    }

    @discardableResult
    func handleFistTimeOpenAlert(dialog: XCUIElement,
                                 location: (StaticString, UInt) = (#file, #line)) -> Bool {
        if dialog.label == "alert", dialog.buttons["Show Application"].exists {
            NSLog("alert: " + dialog.debugDescription)
            XCTAssertTrue(dialog.staticTexts[
                "You are opening the application “\(appNameForTesting)” for the first time. "
                    + "Are you sure you want to open this application?"
            ].exists)
            dialog.buttons["Open"].click()
            RareEventMonitor.log(.firstTimeOpenAlert, location: location)
            return true
        }
        return false
    }

    func skipForOtherTeams() throws {
        let team = workspaceHelper.securityHelper.testDevelopmentTeam()
        try XCTSkipUnless(team == "GB9B5L6A6K", "skipping for team: \(team)")
    }

    func prepare(for test: XCTestCase, location: (StaticString, UInt) = (#file, #line)) {
        let monitor = test.addUIInterruptionMonitor(withDescription: "open first time") { [unowned self] dialog in
            self.handleFistTimeOpenAlert(dialog: dialog, location: location)
        }
        removeMonitor = { test.removeUIInterruptionMonitor(monitor) }
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
