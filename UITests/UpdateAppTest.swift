import XCTest

let kDefaultTimeout: TimeInterval = 5

class UpdateAppTest: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }
    
    func testAutoUpgrade() throws {
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        let updateDialog = app.dialogs["Software Update"]
        updateDialog.waitToAppear()
        updateDialog.staticTexts["Initial Release"].waitToAppear()
        updateDialog.buttons["Install Update"].click()
        
        let updatingWindow = app.windows["Updating SpartaConnect"]
        updatingWindow.staticTexts["Ready to Install"].waitToAppear()
        updatingWindow.buttons["Install and Relaunch"].waitToAppear().click()
        updatingWindow.waitToDisappear()
        
        app.windows["Window"].waitToAppear(timeout: 3 * kDefaultTimeout)
        app.menuBars.menuBarItems["SpartaConnect"].click()
        app.menuBars.menus.menuItems["About SpartaConnect"].click()
        app.dialogs.staticTexts["Version 1.0 (1.0.3)"].waitToAppear()
        app.dialogs.buttons[XCUIIdentifierCloseWindow].click()
    }
}
