import XCTest
import NSBundle_LoginItem

class OpenAtLoginTest: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        removeLoginItem()
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        removeLoginItem()
        app.terminate()
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
