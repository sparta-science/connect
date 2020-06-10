import XCTest
import NSBundle_LoginItem

class LaunchAtLoginTest: XCTestCase {
    
    let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        removeLoginItem()
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        removeLoginItem()
    }
    
    func verifyLoginItemPresent() {
        XCTAssertTrue(app.bundle.isLoginItemEnabled(), "should be enabled")
    }
    
    func removeLoginItem() {
        app.bundle.disableLoginItem()
    }
    
    func testLaunchAtLoginSelectedByDefault() throws {
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["SpartaConnect"].click()
        menuBarsQuery.menuItems["Open At Login"].click()
        verifyLoginItemPresent()
    }
}
