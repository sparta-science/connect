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
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func testLogin() throws {
        let window = XCUIApplication().windows["Window"]
        window.waitToAppear()
        let groups = window.groups
        let popUpButton = groups.children(matching: .popUpButton).element
        popUpButton.click()
        popUpButton.menuItems["localhost"].click()
        
        let textField = groups.children(matching: .textField).element
        textField.click()
        textField.typeText("superuser@example.com")
        let passwordField = groups.children(matching: .secureTextField).element
        passwordField.click()
        passwordField.typeText("password123")

        groups.buttons["connect"].click()
        groups.element.waitToDisappear()
    }
}
