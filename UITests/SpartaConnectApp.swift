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
}
