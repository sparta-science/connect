import XCTest

class MoveToApplicationsTest: XCTestCase {
    let movedUrl = URL(fileURLWithPath: "/Applications/SpartaConnect.app")
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let fileManager = FileManager.default
    let builtApp = XCUIApplication()
    lazy var tempApp = XCUIApplication(url: tempUrl)
    lazy var movedApp = XCUIApplication(url: movedUrl)

    func remove(url: URL) {
        try? fileManager.removeItem(at: url)
        XCTAssertFalse(fileManager.fileExists(atPath: url.path),
                       "should not be in Applications")
    }
    
    func cleanup() {
        [movedUrl, tempUrl].forEach { remove(url: $0) }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        cleanup()
        prepareTempApp()
    }

    override func tearDownWithError() throws {
        cleanup()
        try super.tearDownWithError()
    }
    
    func verifyRunningFromApplications() {
        XCTAssertTrue(movedApp.wait(for: .runningForeground, timeout: 5),
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
    
    func prepareTempApp() {
        let pathBeforeMove = builtApp.value(forKeyPath: "_applicationImpl._path") as! String
        try! fileManager.copyItem(at: URL(fileURLWithPath: pathBeforeMove), to: tempUrl)
        XCTAssertTrue(fileManager.fileExists(atPath: tempUrl.path))
    }

    func testMoveToApplications() throws {
        launchAndChooseToMoveToApplications()
        verifyRunningFromApplications()
    }
}
