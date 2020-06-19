import XCTest

class LoginTest: XCTestCase {

    let app = XCUIApplication()
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launchArguments = [
            "-moveToApplicationsFolderAlertSuppress", "YES",
        ]
        app.launch()
        app.wait(until: .runningBackground)
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }
    
    func activateWindow(window: XCUIElement) {
        window.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 0)).click()
    }

    func testLogin() throws {
        let window = XCUIApplication().windows["Window"]
        window.waitToAppear()
        let groups = window.groups
        XCTAssertEqual(window.popUpButtons.count, 1, "should be only 1 button")
        activateWindow(window: window)
        let popUpButton = window.popUpButtons.element
        popUpButton.clickView()
        popUpButton.menuItems["localhost"].click()
        
        let textField = groups.children(matching: .textField).element
        textField.click()
        textField.typeText("superuser@example.com")
        let passwordField = groups.children(matching: .secureTextField).element
        passwordField.click()
        passwordField.typeText("password123")

        groups.buttons["Login"].click()
        textField.waitToDisappear()
    }
}
