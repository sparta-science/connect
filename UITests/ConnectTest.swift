import XCTest

class ConnectTest: XCTestCase {
    let app = SpartaConnectApp()
    let bundleHelper = BundleHelper()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        executionTimeAllowance = 120
        app.start()
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

    func verifyStartStopScriptsRunWithoutErrorsFromAnyState() throws {
        let activityCommands = [
            "start when already running should ignore Operation already in progress.": "start_vernal_falls",
            "stop when running should sleep 1 second and retry Operation now in progress": "stop_vernal_falls",
            "stop when not running should ignore No such process": "stop_vernal_falls",
            "start when not running should be successful": "start_vernal_falls"
        ]
        let bundle = Bundle(for: type(of: self))
        let homeDirURL = FileManager.default.homeDirectoryForCurrentUser
        let supportFolder = homeDirURL.appendingPathComponent("/Library/Application Support/com.spartascience.SpartaConnect")
        let startTime = Date()
        try activityCommands.forEach { activity, command in
            try XCTContext.runActivity(named: activity) { _ in
                let launcher = ProcessLauncher()
                let startScript = bundle.url(forResource: command, withExtension: "sh")!
                try launcher.runShellScript(script: startScript, in: supportFolder)
            }
        }
        let duration = -startTime.timeIntervalSinceNow
        XCTAssertLessThan(duration, 5, "should run all commands fast")
        if #available(macOS 10.16, *) {
            print("macOS Big Sur Beta launchctl bootout suceeds immediately")
        } else {
            XCTAssertGreaterThan(duration, 1, """
                    should be sleeping at least 1 second when stopping running instance
                    as launchctl returns EINPROGRESS=36 # Operation now in progress
            """)
        }
    }

    func testSuccessfulInstallationAndLaunch() throws {
        XCTContext.runActivity(named: "successful download, installation and launch") { _ in
            app.select(server: "simulate SF State Gators")
            app.enter(username: "anything")
            app.enter(password: "goes")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz")
            verifyInstalled(file: "vernal_falls")
            verifyLaunched(serviceName: "sparta_science.vernal_falls")
            verifyOrgNameDisplayed(orgName: "San Francisco State Gators")
        }
        XCTContext.runActivity(named: "offline installation hides disconnect") { _ in
            let appDefaults = UserDefaults(suiteName: "com.spartascience.SpartaConnect")!
            appDefaults.set(true, forKey: "offline installation")
            let disconnectButton = app.connectWindow().buttons["Disconnect"]
            disconnectButton.waitToDisappear()
            appDefaults.set(false, forKey: "offline installation")
            disconnectButton.waitToAppear()
        }
        try verifyStartStopScriptsRunWithoutErrorsFromAnyState()
        app.disconnect()
        verifyStopped(serviceName: "sparta_science.vernal_falls")

        XCTContext.runActivity(named: "log in with different org") { _ in
            app.select(server: "simulate UC Santa Cruz")
            app.loginButton.click()
            verifyOrgNameDisplayed(orgName: "UC Santa Cruz")
        }
    }

    func verifyOrgNameDisplayed(orgName: String) {
        app.staticTexts[orgName].waitToAppear()
    }

    func testFailedInstallation() throws {
        XCTContext.runActivity(named: "successful download but failed installation") { _ in
            app.select(server: "simulate install failure")
            app.enter(username: "a")
            app.enter(password: "b")
            app.loginButton.click()

            verifyInstalled(file: "vernal_falls_config.yml")
            verifyInstalled(file: "vernal_falls.tar.gz", timeout: .network)
            app.dismiss(alert: "Failed with exit code: 1", byClicking: "OK")
            app.loginButton.waitToAppear()
        }
    }

    func testInvalidLogin() throws {
        XCTAssertEqual(app.connectWindow().popUpButtons.count, 1,
                       "should be only 1 button")
        XCTContext.runActivity(named: "invalid login") { _ in
            app.select(server: "production")
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
