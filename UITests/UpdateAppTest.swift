import XCTest

let kDefaultTimeout: TimeInterval = 5

class UpdateAppTest: XCTestCase {
    let tempAppHelper = TempAppHelper()
    lazy var app = tempAppHelper.tempApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        tempAppHelper.prepare()
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
        app.launch()
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
        checkForUpdatesAndInstall()
        installAndRelaunch()
        verifyUpdated()
    }
}
