import XCTest

let kDefaultTimeout: TimeInterval = 5

class UpdateAppTest: XCTestCase {
    let tempAppHelper = TempAppHelper()
    lazy var app = tempAppHelper.tempApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        tempAppHelper.prepare()
        tempAppHelper.clearDefaults()
        tempAppHelper.clearCache()
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
    }

    override func tearDownWithError() throws {
        app.terminate()
        tempAppHelper.cleanup()
        try super.tearDownWithError()
    }
    
    func checkForUpdatesAndInstall() {
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        let updateDialog = app.dialogs["Software Update"]
        updateDialog.waitToAppear()
        XCTAssertTrue(updateDialog
            .checkBoxes["Automatically download and install updates in the future"]
            .value as! Bool, "should be enabled")
        updateDialog.staticTexts["Initial Release"].waitToAppear()
        updateDialog.buttons["Install Update"].click()
    }
    
    func installAndRelaunch() {
        let updatingWindow = app.windows["Updating SpartaConnect"]
        updatingWindow.staticTexts["Ready to Install"].waitToAppear()
        updatingWindow.buttons["Install and Relaunch"].waitToAppear().click()
        updatingWindow.waitToDisappear()
        XCTAssertTrue(app.wait(for: .notRunning, timeout: 1), "wait for app to terminate")
    }
    
    func verifyUpdated() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "wait for app to relaunch")
        app.windows["Window"].waitToAppear(timeout: 3 * kDefaultTimeout)
        app.menuBars.menuBarItems["SpartaConnect"].click()
        app.menuBars.menus.menuItems["About SpartaConnect"].click()
        app.dialogs.staticTexts["Version 1.0 (1.0.3)"].waitToAppear()
        app.dialogs.buttons[XCUIIdentifierCloseWindow].click()
    }
    
    func testAutoUpgrade() throws {
        tempAppHelper.persistDefaults([
            "SULastCheckTime": Date()
        ])
        app.launch()
        checkForUpdatesAndInstall()
        installAndRelaunch()
        verifyUpdated()
    }
    
    func quitApp() {
        app.activate()
        app.menuBars.menuBarItems["SpartaConnect"].click()
        app.menuItems["Quit SpartaConnect"].click()
        XCTAssertTrue(app.wait(for: .notRunning, timeout: 5 * kDefaultTimeout))
    }
    
    func checkUpdateDownloads() -> NSPredicate {
        tempAppHelper.hasDownloaded(fileName: "SpartaConnect.app")
    }
    
    func waitForUpdatesDownloaded() {
        let expectDownload = expectation(for: checkUpdateDownloads(), evaluatedWith: nil)
        wait(for: [expectDownload], timeout: 20 * kDefaultTimeout)
    }
    
    func waitForUpdatesInstalled() {
        let predicate = NSCompoundPredicate(notPredicateWithSubpredicate: checkUpdateDownloads())
        let expectDownload = expectation(for: predicate, evaluatedWith: nil)
        wait(for: [expectDownload], timeout: 5 * kDefaultTimeout)
    }

    
    func testUpgradeOnQuit() {
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: kDefaultTimeout))
        waitForUpdatesDownloaded()
        quitApp()
        waitForUpdatesInstalled()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: kDefaultTimeout))
        verifyUpdated()
    }
}
