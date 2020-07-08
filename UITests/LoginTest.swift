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

    func testClickConnectShowsConnectWindow() {
        app.closeConnectWindow()
        app.showConnectWindow()
    }

    func testHappyValidLogin() throws {
        XCTContext.runActivity(named: "successful login with successful download") { _ in
            app.select(server: "fake server")
            app.enter(username: "a")
            app.enter(password: "b")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
        }
        app.disconnect()
    }

    func testInvalidLogin() throws {
        XCTAssertEqual(app.connectWindow().popUpButtons.count, 1,
                       "should be only 1 button")
        XCTContext.runActivity(named: "invalid login") { _ in
            app.select(server: "staging")
            XCTAssertFalse(app.loginButton.isEnabled,
                           "should be disabled until form is filled out")

            app.enter(username: "user@example.com")
            XCTAssertFalse(app.loginButton.isEnabled,
                           "should be disabled until form is filled out")
            app.enter(password: "password")
            app.loginButton.click()
            app.dismiss(alert: "Email and password are not valid", byClicking: "OK")
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
