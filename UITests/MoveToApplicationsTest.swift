import XCTest

class MoveToApplicationsTest: XCTestCase {
    let moveAppHelper = MoveAppHelper()
    lazy var tempApp = moveAppHelper.tempApp()
    lazy var movedApp = moveAppHelper.movedApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        executionTimeAllowance = 60
        moveAppHelper.prepare(for: self)
    }

    override func tearDownWithError() throws {
        if testRun?.totalFailureCount == 0 {
            moveAppHelper.cleanup()
        }
        try super.tearDownWithError()
    }

    func verifyRunningFromApplications() {
        moveAppHelper.waitForAppToLaunchDismissingFirstTimeOpenAlerts(app: movedApp)
        movedApp.terminate()
    }

    func launchAndChooseToMoveToApplications() {
        moveAppHelper.launch()
        let alert = tempApp.waitForMoveAlert()
        alert.buttons["Move to Applications Folder"].click()
        alert.waitToDisappear()
        tempApp.wait(until: .notRunning, "wait for app to terminate")
    }

    func testMoveToApplications() throws {
        launchAndChooseToMoveToApplications()
        verifyRunningFromApplications()
    }
}
