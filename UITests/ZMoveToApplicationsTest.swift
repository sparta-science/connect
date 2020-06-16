import XCTest

class ZMoveToApplicationsTest: XCTestCase {
    let moveAppHelper = MoveAppHelper()
    lazy var tempApp = moveAppHelper.tempApp()
    lazy var movedApp = moveAppHelper.movedApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        moveAppHelper.prepare(for: self)
    }

    override func tearDownWithError() throws {
        if testRun?.hasSucceeded == true {
            moveAppHelper.cleanup()
        }
        try super.tearDownWithError()
    }
    
    func verifyRunningFromApplications() {
        movedApp.wait(until: .runningBackground, "wait for app to restart from /Applications")
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
