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

    func testSuccessfullInstallation() throws {
        XCTContext.runActivity(named: "successful download but failed installation") { _ in
            app.select(server: "simulate install success")
            app.enter(username: "anything")
            app.enter(password: "goes")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
            verifyInstalled(file: "vernal_falls")
        }
        app.disconnect()
    }

    func testFailedInstallation() throws {
        XCTContext.runActivity(named: "successful download but failed installation") { _ in
            app.select(server: "simulate install failure")
            app.enter(username: "a")
            app.enter(password: "b")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
            app.dismiss(alert: "Failed to install with exit code: 1", byClicking: "OK")
            app.loginButton.waitToAppear()
        }
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
            app.enter(password: "password\n")
            app.dismiss(alert: "Email and password are not valid", byClicking: "OK")
        }
    }

    func verifyInstalled(file: String) {
        let checkForFile = bundleHelper.findInstalled(file: file)
        let isFileInstalled = XCTNSPredicateExpectation(predicate: checkForFile, object: nil)
        XCTWaiter.wait(until: isFileInstalled, file + " should be installed")
    }
}
