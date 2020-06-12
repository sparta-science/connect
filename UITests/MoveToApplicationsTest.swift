import XCTest

class MoveToApplicationsTest: XCTestCase {
    let moveAppHelper = MoveAppHelper()
    lazy var tempApp = moveAppHelper.tempApp()
    lazy var movedApp = moveAppHelper.movedApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        moveAppHelper.prepare()
    }

    override func tearDownWithError() throws {
        moveAppHelper.cleanup()
        try super.tearDownWithError()
    }
    
    func verifyRunningFromApplications() {
        XCTAssertTrue(movedApp.wait(for: .runningBackground, timeout: 5),
                      "wait for app to restart from /Applications")
        movedApp.terminate()
    }
    
    func launchAndChooseToMoveToApplications() {
        tempApp.launch()
        let alert = tempApp.dialogs["alert"]
        alert.staticTexts["Move to Applications folder?"].waitToAppear()
        alert.buttons["Move to Applications Folder"].click()
        alert.waitToDisappear()
        XCTAssertTrue(tempApp.wait(for: .notRunning, timeout: 1), "wait for app to terminate")
    }
    
    func testMoveToApplications() throws {
        launchAndChooseToMoveToApplications()
        verifyRunningFromApplications()
    }
}
