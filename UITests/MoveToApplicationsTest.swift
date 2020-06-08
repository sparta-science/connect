import XCTest

class MoveToApplicationsTest: XCTestCase {
    let movedUrl = URL(fileURLWithPath: "/Applications/SpartaConnect.app")
    let fileManager = FileManager.default
    let app = XCUIApplication()
    
    func removeFromApplications() {
        try? fileManager.removeItem(at: movedUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: movedUrl.path),
                       "should not be in Applications")
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        removeFromApplications()
    }

    override func tearDownWithError() throws {
        removeFromApplications()
        try super.tearDownWithError()
    }
    
    func verifyRunningFromApplications() {
        let restarted = XCUIApplication(url: movedUrl)
        XCTAssertTrue(restarted.wait(for: .runningForeground, timeout: 5),
                      "wait for app to restart from /Applications")
        restarted.terminate()
    }
    
    func launchAndChooseToMove() {
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "NO",
        ]
        app.launch()
        let alert = app.dialogs["alert"]
        alert.staticTexts["Move to Applications folder?"].waitToAppear()
        alert.buttons["Move to Applications Folder"].click()
    }
    
    func restoreOriginalPath(path: String) {
        try? fileManager.moveItem(at: movedUrl, to: URL(fileURLWithPath: path))
        XCTAssertTrue(fileManager.fileExists(atPath: path))
    }

    func testMoveToApplications() throws {
        let pathBeforeMove = app.value(forKeyPath: "_applicationImpl._path") as! String
        launchAndChooseToMove()
        XCTAssertTrue(app.wait(for: .notRunning, timeout: 1), "wait for app to terminate")
        verifyRunningFromApplications()
        restoreOriginalPath(path: pathBeforeMove)
    }
}
