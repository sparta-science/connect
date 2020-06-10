import XCTest

let kDefaultTimeout: TimeInterval = 5

class UpdateAppTest: XCTestCase {
    let tempAppHelper = TempAppHelper()
    lazy var app = tempAppHelper.tempApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        tempAppHelper.prepare()
        tempAppHelper.bundleHelper.clearDefaults()
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
        XCTAssertTrue(app.wait(for: .notRunning, timeout: kDefaultTimeout), "wait for app to terminate")
        
    }
    
    func dismissMoveToApplicationsAlert() {
        let alert = app.dialogs["alert"]
        alert.staticTexts["Move to Applications folder?"].waitToAppear()
        alert.buttons["Do Not Move"].click()
        alert.waitToDisappear()
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
        tempAppHelper.bundleHelper.persistDefaults([
            "SULastCheckTime": Date()
        ])
        app.launch()
        checkForUpdatesAndInstall()
        installAndRelaunch()
        dismissMoveToApplicationsAlert()
        verifyUpdated()
    }
    
    func quitApp() {
        app.activate()
        app.menuBars.menuBarItems["SpartaConnect"].click()
        app.menuItems["Quit SpartaConnect"].click()
        XCTAssertTrue(app.wait(for: .notRunning, timeout: 5 * kDefaultTimeout))
    }
    
    func checkUpdateDownloaded() -> NSPredicate {
        tempAppHelper.hasDownloaded(fileName: "SpartaConnect.app")
    }
    
    func waitForUpdatesDownloaded() {
        let downloadComplete = expectation(for: checkUpdateDownloaded(), evaluatedWith: nil)
        let downloadTimeout = 20 * kDefaultTimeout
        wait(for: [downloadComplete], timeout: downloadTimeout)
    }
    
    func waitForUpdatesInstalled() {
        let downloadedDeleted = NSCompoundPredicate(
            notPredicateWithSubpredicate: checkUpdateDownloaded()
        )
        let expectDownload = expectation(for: downloadedDeleted, evaluatedWith: nil)
        let installTimeout = 5 * kDefaultTimeout
        wait(for: [expectDownload], timeout: installTimeout)
    }
    
    func checkForUpdatesAndInstallOnQuit() {
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        let popup = app.windows.containing(.button, identifier:"Install and Relaunch").element
        popup.waitToAppear()

        XCTAssertTrue(popup
            .staticTexts["A new version of SpartaConnect is ready to install!"].exists)
        XCTAssertTrue(popup.buttons["Don't Install"].exists)
        popup.buttons["Install on Quit"].click()
        popup.waitToDisappear()
    }

    
    func testUpgradeOnQuit() {
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: kDefaultTimeout))
        waitForUpdatesDownloaded()
        checkForUpdatesAndInstallOnQuit()
        quitApp()
        waitForUpdatesInstalled()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: kDefaultTimeout))
        verifyUpdated()
    }
}
