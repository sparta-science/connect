import XCTest

class SpartaConnectApp: XCUIApplication {
    func start(allowMove: Bool = false) {
        XCTContext.runActivity(named: "start app" + (allowMove ? " allowing to move": "")) { _ in
            if !allowMove {
                launchArguments = [
                    "-moveToApplicationsFolderAlertSuppress", "YES"
                ]
            }
            launch()
        }
    }
    func waitForAnimationsToFinish() {
        activate()
    }
    func waitForMoveAlert() -> XCUIElement {
        XCTContext.runActivity(named: "wait for move alert") { _ in
            let alert = dialogs["alert"]
            alert.staticTexts["I can move myself to the Applications folder if you'd like."]
                .waitToAppear(time: .install)
            waitForAnimationsToFinish()
            return alert
        }
    }
    func connectWindow() -> XCUIElement {
        windows["Connect to Sparta Science"]
    }
    enum Identifier: String {
        case statusBarItem = "Sparta"
    }

    func statusBarMenu() -> XCUIElement {
        statusBarItem().menus.element
    }

    func statusBarItem() -> XCUIElement {
        statusBarItem(Identifier.statusBarItem.rawValue)
    }

    func clickStatusItem() {
        repeat {
            statusBarItem().clickView()
        } while !statusBarMenu().waitForExistence()
    }
    func enter(username: String) {
        descendants(matching: .textField).element.clickAndType(username)
    }
    func enter(password: String) {
        descendants(matching: .secureTextField).element.clickAndType(password)
    }
    func select(server environment: String) {
        let window = connectWindow()
        window.activateWindow()
        let popUpButton = window.popUpButtons.element
        popUpButton.clickView()
        popUpButton.menuItems[environment].click()
    }

    func closeConnectWindow() {
        XCTContext.runActivity(named: "close connect window") { _ in
            let window = connectWindow()
            window.waitToAppear()
            window.click()
            window.buttons["Done"].click()
        }
    }
    @discardableResult
    func showConnectWindow() -> XCUIElement {
        XCTContext.runActivity(named: "show connect window") { _ in
            clickStatusItem()
            statusBarMenu().menuItems["Connect..."].click()
            connectWindow().waitToAppear()
            return connectWindow()
        }
    }
    var loginButton: XCUIElement {
        connectWindow().groups.buttons["Login"]
    }
    var orgNameLabel: XCUIElement {
        connectWindow().staticTexts["organization"]
    }
    func disconnect() {
        XCTContext.runActivity(named: "disconnect") { _ in
            let disconnectButton = connectWindow().buttons["Disconnect"]
            disconnectButton.click()
            disconnectButton.waitToDisappear()
        }
    }
    func dismiss(alert: String, byClicking button: String) {
        dialogs.staticTexts[alert].waitToAppear()
        dialogs.buttons[button].click()
    }
}
