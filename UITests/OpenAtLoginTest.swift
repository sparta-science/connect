import NSBundle_LoginItem
import XCTest

class OpenAtLoginTest: XCTestCase {
    let app = SpartaConnectApp()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        removeLoginItem()
        app.start()
    }

    override func tearDownWithError() throws {
        removeLoginItem()
        app.terminate()
        app.wait(until: .notRunning)
        try super.tearDownWithError()
    }

    func verifyLoginItem(enabled: Bool) {
        XCTAssertEqual(enabled, app.bundle.isLoginItemEnabled(), "should be enabled")
    }

    func removeLoginItem() {
        app.bundle.disableLoginItem()
    }

    func testOpenAtLoginAddsLoginItem() throws {
        app.clickStatusItem()

        let openAtLoginMenuItem = app.statusBarMenu().menuItems["Open at Login"]
        openAtLoginMenuItem.click()
        verifyLoginItem(enabled: true)

        app.clickStatusItem()
        openAtLoginMenuItem.click()
        verifyLoginItem(enabled: false)
    }
}
