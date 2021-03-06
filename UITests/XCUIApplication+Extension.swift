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

    func statusBarMenu(_ identifier: String) -> XCUIElement {
        statusBarItem(identifier).menus.element
    }

    func statusBarItem(_ identifier: String) -> XCUIElement {
        menuBars.statusItems.element(matching: .statusItem, identifier: identifier)
    }

    @discardableResult
    func wait(for state: XCUIApplication.State, timeout: Timeout = .test) -> Bool {
        wait(for: state, timeout: timeout.rawValue)
    }

    func clickStatusItem(_ identifier: String) {
        repeat {
            statusBarItem(identifier).clickView()
        } while !statusBarMenu(identifier).waitForExistence()
    }

    func wait(until newState: XCUIApplication.State,
              timeout: Timeout = .test,
              _ reason: String = "waiting for app state",
              file: StaticString = #file,
              line: UInt = #line) {
        XCTAssertTrue(
            wait(for: newState, timeout: timeout.rawValue),
            reason + ": \(newState) got \(state)",
            file: file,
            line: line
        )
    }
}

extension XCUIApplication.State: CustomStringConvertible {
    public var description: String {
        [
            "unknown",
            "notRunning",
            "undocumented",
            "runningBackground",
            "runningForeground"
        ][Int(rawValue)]
    }
}
