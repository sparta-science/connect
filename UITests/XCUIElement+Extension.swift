import XCTest

extension XCUIElement {
    func has(debugLabel: String) -> Bool {
        guard let endOfLine = debugDescription.firstIndex(of: "\n") else {
            return false
        }
        let firstLine = debugDescription[..<endOfLine]
        return firstLine.contains("label: '\(debugLabel)'")
    }
    func waitToDisappear(timeout: Timeout = .test,
                         file: StaticString = #file, line: UInt = #line) {
        let doesNotExists = NSPredicate(format: "exists == false")
        let disappered = XCTNSPredicateExpectation(predicate: doesNotExists, object: self)
        XCTWaiter.wait(
            until: disappered,
            timeout: timeout,
            "\(self) has not disappeared",
            file: file,
            line: line
        )
    }

    @discardableResult
    func waitToAppear(time timeout: Timeout = .test,
                      file: StaticString = #file,
                      line: UInt = #line) -> XCUIElement {
        XCTAssertTrue(waitForExistence(timeout: timeout),
                      "\(self) has not appeared", file: file, line: line)
        XCTAssertTrue(exists, "\(self) does not exists", file: file, line: line)
        return self
    }

    func waitForExistence(timeout: Timeout = .test) -> Bool {
        waitForExistence(timeout: timeout.rawValue)
    }

    @discardableResult
    func waitToBeClickable(timeout: Timeout = .test,
                           file: StaticString = #file,
                           line: UInt = #line) -> XCUIElement {
        let hittable = NSPredicate(format: "hittable == true")
        let becameHittable = XCTNSPredicateExpectation(predicate: hittable, object: self)
        XCTWaiter.wait(
            until: becameHittable,
            timeout: timeout,
            "\(self) has not became hittable, isHittable:\(isHittable)",
            file: file,
            line: line
        )
        return self
    }

    func clickView() {
        coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).click()
    }
}
