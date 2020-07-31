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

    func testSuccessfullInstallationAndLaunch() throws {
        XCTContext.runActivity(named: "successful download, installation and launch") { _ in
            app.select(server: "simulate install success")
            app.enter(username: "anything")
            app.enter(password: "goes")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
            verifyInstalled(file: "vernal_falls")
            verifyLaunched(serviceName: "sparta_science.vernal_falls")
        }
        app.disconnect()
        verifyStopped(serviceName: "sparta_science.vernal_falls")
    }

    func testFailedInstallation() throws {
        XCTContext.runActivity(named: "successful download but failed installation") { _ in
            app.select(server: "simulate install failure")
            app.enter(username: "a")
            app.enter(password: "b")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz", timeout: .network)
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

    func verifyLaunched(serviceName: String,
                        _ source: StaticString = #file,
                        _ line: UInt = #line) {
        let isLaunched = XCTestExpectation(description: serviceName + " has been launched")
        try! NSUserUnixTask(url: URL(fileURLWithPath: "/bin/launchctl"))
            .execute(withArguments: ["blame", "gui/\(getuid())/\(serviceName)"]) { error in
            XCTAssertNil(error, "should be launched successfully")
            isLaunched.fulfill()
            }
        XCTWaiter.wait(until: isLaunched,
                       timeout: .launch,
                       serviceName + " should be launched",
                       file: source,
                       line: line)
    }

    func verifyStopped(serviceName: String,
                        _ source: StaticString = #file,
                        _ line: UInt = #line) {
        let noSuchService = Int(ENOENT)
        let hasBeenStopped = XCTestExpectation(description: serviceName + " has been stopped")
        try! NSUserUnixTask(url: URL(fileURLWithPath: "/bin/launchctl"))
            .execute(withArguments: ["blame", "gui/\(getuid())/\(serviceName)"]) { error in
                let nsError = error! as NSError
                XCTAssertEqual(noSuchService, nsError.code, "should be stopped")
                hasBeenStopped.fulfill()
            }
        XCTWaiter.wait(until: hasBeenStopped,
                       timeout: .launch,
                       serviceName + " should be launched",
                       file: source,
                       line: line)
    }

    func verifyInstalled(file: String, timeout: Timeout = .test,
                         _ source: StaticString = #file,
                         _ line: UInt = #line) {
        let checkForFile = bundleHelper.findInstalled(file: file)
        let isFileInstalled = XCTNSPredicateExpectation(predicate: checkForFile, object: nil)
        XCTWaiter.wait(until: isFileInstalled,
                       timeout: timeout,
                       file + " should be installed",
                       file: source,
                       line: line)
    }
}
