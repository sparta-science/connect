import XCTest

let kDefaultTimeout: TimeInterval = 5

class UpdateAppTest: XCTestCase {
    let tempAppHelper = TempAppHelper()
    lazy var app = tempAppHelper.tempApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        tempAppHelper.prepare(for: self)
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
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Check for updates..."].click()
        let updateDialog = app.windows["Software Update"]
        updateDialog.waitToAppear()
        XCTAssertTrue(updateDialog
            .checkBoxes["Automatically download and install updates in the future"]
            .value as! Bool, "should be enabled")
        updateDialog.staticTexts["Initial Release"].waitToAppear()
        updateDialog.buttons["Install Update"].click()
    }
    
    func installAndRelaunch() {
        let updatingWindow = app.windows["Updating SpartaConnect"]
        updatingWindow.waitToAppear(timeout: 2 * kDefaultTimeout)
        updatingWindow.staticTexts["Ready to Install"].waitToAppear()
        let appUrl = app.url
        updatingWindow.buttons["Install and Relaunch"].waitToAppear().click()
        app.wait(until: .notRunning, "wait for app to terminate")
        LaunchService.waitForAppToBeReadyForLaunch(at: appUrl)
        app.wait(until: .runningForeground, "wait for app to relaunch")
    }
    
    func dismissMoveToApplicationsAlert() {
        let alert = app.dialogs["alert"]
        alert.staticTexts["Move to Applications folder?"].waitToAppear()
        alert.buttons["Do Not Move"].click()
        alert.waitToDisappear()
    }
    
    
    func verifyUpdated() {
        app.wait(until: .runningForeground, timeout: 5, "wait for app to relaunch")
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
        app.wait(until: .notRunning)
        app.launch()
        app.wait(until: .runningBackground)
        checkForUpdatesAndInstall()
        installAndRelaunch()
        dismissMoveToApplicationsAlert()
        verifyUpdated()
    }
    
    func quitApp() {
        app.activate()
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Quit SpartaConnect"].click()
        app.wait(until: .notRunning, timeout: 5 * kDefaultTimeout)
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
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Check for updates..."].click()
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
        app.wait(until: .runningBackground)
        waitForUpdatesDownloaded()
        checkForUpdatesAndInstallOnQuit()
        quitApp()
        waitForUpdatesInstalled()
        app.launch()
        app.wait(until: .runningForeground)
        verifyUpdated()
    }
}
