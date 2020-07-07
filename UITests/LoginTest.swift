import XCTest

class LoginTest: XCTestCase {
    let app = SpartaConnectApp()
    let bundleHelper = BundleHelper()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.start()
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

    func testValidAndInvalidLogin() throws {
        let window = app.mainWindow()
        window.waitToAppear()
        let groups = window.groups
        XCTAssertEqual(window.popUpButtons.count, 1, "should be only 1 button")
        activateWindow(window: window)
        let popUpButton = window.popUpButtons.element
        let loginButton = groups.buttons["Login"]
        let textField = groups.children(matching: .textField).element
        let passwordField = groups.children(matching: .secureTextField).element

        XCTContext.runActivity(named: "invalid login") { _ in
            popUpButton.clickView()
            popUpButton.menuItems["staging"].click()

            XCTAssertFalse(loginButton.isEnabled, "should be disabled until form is filled out")

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
        }

        XCTContext.runActivity(named: "successful login") { _ in
            activateWindow(window: window)
            popUpButton.clickView()
            popUpButton.menuItems["fake server"].click()
            textField.click()
            textField.typeText("a")
            passwordField.click()
            passwordField.typeText("b")
            loginButton.click()
            window.buttons["Disconnect"].waitToAppear()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
        }
        XCTContext.runActivity(named: "disconnect") { _ in
            window.buttons["Disconnect"].click()
            textField.waitToAppear()
        }

        window.click()
        window.buttons["Done"].click()
        window.waitToDisappear()

        verifyConnectShowsLogin()
    }

    func verifyInstalled(file: String) {
        let checkForFile = bundleHelper.findInstalled(file: file)
        let fileFound = expectation(for: checkForFile,
                                           evaluatedWith: nil)
        fileFound.expectationDescription = "finding file: " + file
        wait(for: [fileFound], timeout: Timeout.test.rawValue)
    }

    func verifyConnectShowsLogin() {
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Connect..."].click()
        app.mainWindow().waitToAppear()
    }
}
