import XCTest

class LoginTest: XCTestCase {
    let app = SpartaConnectApp()
    let bundleHelper = BundleHelper()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.start()
        bundleHelper.eraseInstallation()
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

    func testClickConnectShowsConnectWindow() {
        app.closeConnectWindow()
        app.clickStatusItem()
        app.statusBarMenu().menuItems["Connect..."].click()
        app.connectWindow().waitToAppear()
    }

    func testHappyValidLogin() throws {
        let window = app.connectWindow()
        let disconnectButton = window.buttons["Disconnect"]
        XCTContext.runActivity(named: "successful login with successful download") { _ in
            app.select(server: "fake server")
            app.enter(username: "a")
            app.enter(password: "b")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
        }
        XCTContext.runActivity(named: "disconnect") { _ in
            disconnectButton.click()
            disconnectButton.waitToDisappear()
        }
    }

    func testInvalidLogin() throws {
        let window = app.connectWindow()
        XCTAssertEqual(window.popUpButtons.count, 1, "should be only 1 button")
        activateWindow(window: window)
        XCTContext.runActivity(named: "invalid login") { _ in
            app.select(server: "staging")
            XCTAssertFalse(app.loginButton.isEnabled,
                           "should be disabled until form is filled out")

            app.enter(username: "user@example.com")
            XCTAssertFalse(app.loginButton.isEnabled,
                           "should be disabled until form is filled out")
            app.enter(password: "password")
            app.loginButton.click()
            app.dialogs.staticTexts["Email and password are not valid"].waitToAppear()
            app.dialogs.buttons["OK"].click()
        }
    }

    func verifyInstalled(file: String) {
        let checkForFile = bundleHelper.findInstalled(file: file)
        let fileFound = expectation(for: checkForFile,
                                           evaluatedWith: nil)
        fileFound.expectationDescription = "finding file: " + file
        wait(for: [fileFound], timeout: Timeout.test.rawValue)
    }
}
