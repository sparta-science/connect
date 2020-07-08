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
    func waitForMoveAlert() -> XCUIElement {
        XCTContext.runActivity(named: "wait for move alert") { _ in
            let alert = dialogs["alert"]
            alert.staticTexts["I can move myself to the Applications folder if you'd like."]
                .waitToAppear(time: .install)
            return alert
        }
    }
    func mainWindow() -> XCUIElement {
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
}
