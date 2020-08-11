import XCTest

class AlreadyUpToDateTest: XCTestCase {
    let tempAppHelper = TempAppHelper()
    lazy var app = SpartaConnectApp()
    let arguments = ["-moveToApplicationsFolderAlertSuppress", "YES"]

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func testAlreadyUpToDate() {
        app.launchArguments = arguments
        app.launch()
        checkForUpdates()
        verifyUpToDate()
    }

    func checkForUpdates() {
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Check for updates..."].click()
    }

    func verifyUpToDate() {
        let updateAlert = app.dialogs["alert"]
        updateAlert.waitToAppear()
        print(app.debugDescription)

        updateAlert.staticTexts["You’re up-to-date!"].waitToAppear()
        updateAlert.buttons["OK"].click()
    }
}
