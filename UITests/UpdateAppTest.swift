import XCTest

let kDefaultTimeout: TimeInterval = 5

class UpdateAppTest: XCTestCase {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let fileManager = FileManager.default
    let builtApp = XCUIApplication()
    lazy var tempApp = XCUIApplication(url: tempUrl)

    func remove(url: URL) {
        try? fileManager.removeItem(at: url)
        XCTAssertFalse(fileManager.fileExists(atPath: url.path),
                       "should not be in Applications")
    }
    
    func cleanup() {
        remove(url: tempUrl)
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        cleanup()
        prepareTempApp()
        tempApp.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
        tempApp.launch()
    }

    override func tearDownWithError() throws {
        tempApp.terminate()
        cleanup()
        try super.tearDownWithError()
    }
    
    func prepareTempApp() {
        let pathBeforeMove = builtApp.value(forKeyPath: "_applicationImpl._path") as! String
        try! fileManager.copyItem(at: URL(fileURLWithPath: pathBeforeMove), to: tempUrl)
        XCTAssertTrue(fileManager.fileExists(atPath: tempUrl.path))
    }
    
    func checkForUpdatesAndInstall() {
        let menuBarsQuery = tempApp.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        let updateDialog = tempApp.dialogs["Software Update"]
        updateDialog.waitToAppear()
        updateDialog.staticTexts["Initial Release"].waitToAppear()
        updateDialog.buttons["Install Update"].click()
    }
    
    func installAndRelaunch() {
        let updatingWindow = tempApp.windows["Updating SpartaConnect"]
        updatingWindow.staticTexts["Ready to Install"].waitToAppear()
        updatingWindow.buttons["Install and Relaunch"].waitToAppear().click()
        updatingWindow.waitToDisappear()
        XCTAssertTrue(tempApp.wait(for: .notRunning, timeout: 1), "wait for app to terminate")
    }
    
    func verifyUpdated() {
        XCTAssertTrue(tempApp.wait(for: .runningForeground, timeout: 5), "wait for app to relaunch")
        tempApp.windows["Window"].waitToAppear(timeout: 3 * kDefaultTimeout)
        tempApp.menuBars.menuBarItems["SpartaConnect"].click()
        tempApp.menuBars.menus.menuItems["About SpartaConnect"].click()
        tempApp.dialogs.staticTexts["Version 1.0 (1.0.3)"].waitToAppear()
        tempApp.dialogs.buttons[XCUIIdentifierCloseWindow].click()
    }
    
    func testAutoUpgrade() throws {
        checkForUpdatesAndInstall()
        installAndRelaunch()
        verifyUpdated()        
    }
}
