import XCTest

extension XCUIApplication {
    var path: String {
        value(forKeyPath: "_applicationImpl._path") as! String
    }
    var bundle: Bundle {
        Bundle(path: path)!
    }
    var url: URL {
        URL(fileURLWithPath: path)
    }

    func statusBarMenu() -> XCUIElement {
        statusBarItem().menus.element
    }

    func statusBarItem() -> XCUIElement {
        menuBars.statusItems.element(matching: .statusItem, identifier: "Sparta")
    }
    
    @discardableResult
    func wait(for state: XCUIApplication.State, timeout: Timeout = .test) -> Bool {
        wait(for: state, timeout: timeout.rawValue)
    }

    func clickStatusItem() {
        repeat {
            statusBarItem().coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).click()
        } while !statusBarMenu().waitForExistence()
    }
    
    func wait(until newState: XCUIApplication.State,
              timeout: Timeout = .test,
              _ reason: String = "waiting for app state, ",
              file: StaticString = #file,
              line: UInt = #line) {
        XCTAssertTrue(
            wait(for: newState, timeout: timeout.rawValue),
            reason + " got \(state.rawValue)",
            file: file,
            line: line
        )
    }

    // MARK: Project specific

    func waitForMoveAlert() -> XCUIElement {
        let alert = dialogs["alert"]
        alert.staticTexts["I can move myself to the Applications folder if you'd like."]
            .waitToAppear(time: .install)
        return alert
    }
}
