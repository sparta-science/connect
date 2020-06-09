import XCTest

class LauchAtLoginTest: XCTestCase {
    
    let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        verifyLoginItemPresent()
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
        let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as! LSSharedFileList
        let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
        (0..<loginItems.count).forEach { i in
            let currentItemRef: LSSharedFileListItem = loginItems.object(at: i) as! LSSharedFileListItem
            if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                print(itemURL.takeRetainedValue())
            }
        }
    }
    
    func removeLoginItem() {
        
    }
    func testLaunchAtLoginSelectedByDefault() throws {
        
        
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["SpartaConnect"].click()
        menuBarsQuery.menuItems["Open At Login"].click()
        verifyLoginItemPresent()
    }
    
}
