import XCTest

class LoginTest: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES"
        ]
        app.launch()
        app.activate()
        app.wait(until: .runningForeground)
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func activateWindow(window: XCUIElement) {
        window.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 0)).click()
    }

    func testInvalidLogin() throws {
        let window = app.mainWindow()
        window.waitToAppear()
        let groups = window.groups
        XCTAssertEqual(window.popUpButtons.count, 1, "should be only 1 button")
        activateWindow(window: window)
        let popUpButton = window.popUpButtons.element
        popUpButton.clickView()
        popUpButton.menuItems["staging"].click()

        let loginButton = groups.buttons["Login"]
        XCTAssertFalse(loginButton.isEnabled, "should be disabled until form is filled out")

        let textField = groups.children(matching: .textField).element
        textField.click()
        textField.typeText("user@example.com")
        XCTAssertFalse(loginButton.isEnabled, "should be disabled until form is filled out")

        let passwordField = groups.children(matching: .secureTextField).element
        passwordField.click()
        passwordField.typeText("password")

        loginButton.click()
        textField.waitToDisappear()
        app.dialogs.staticTexts["Email and password are not valid"].waitToAppear()
        app.dialogs.buttons["OK"].click()
        window.buttons["Done"].click()

        verifyConnectShowsLogin()
    }

    func verifyConnectShowsLogin() {
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Connect..."].click()
        app.mainWindow().waitToAppear()
    }
}
