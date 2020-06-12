import XCTest
import NSBundle_LoginItem

class LaunchAtLoginTest: XCTestCase {
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
        try super.tearDownWithError()
    }
    
    func verifyLoginItem(enabled: Bool) {
        XCTAssertEqual(enabled, app.bundle.isLoginItemEnabled(), "should be enabled")
    }
    
    func removeLoginItem() {
        app.bundle.disableLoginItem()
    }
    
    func testLaunchAtLoginSelectedByDefault() throws {        
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.statusItems.element
        statusItem.click()
        
        let openAtLoginMenuItem = menuBarsQuery.menuItems["Open at Login"]
        openAtLoginMenuItem.click()
        verifyLoginItem(enabled: true)

        statusItem.click()
        openAtLoginMenuItem.click()
        verifyLoginItem(enabled: false)
    }
}
