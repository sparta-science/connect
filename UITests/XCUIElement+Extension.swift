import XCTest

extension XCUIElement {
    func has(debugLabel: String) -> Bool {
        guard let endOfLine = debugDescription.firstIndex(of: "\n") else {
            return false
        }
        let firstLine = debugDescription[..<endOfLine]
        return firstLine.contains("label: '\(debugLabel)'")
    }
    func waitToDisappear(timeout: TimeInterval = kDefaultTimeout, file: StaticString = #file, line: UInt = #line) {
        let doesNotExists = NSPredicate(format: "exists == false")
        let disappered = XCTNSPredicateExpectation(predicate: doesNotExists, object: self)
        let waiter = XCTWaiter()
        XCTAssertEqual(waiter.wait(for: [disappered], timeout: timeout), .completed,
                       "\(self) has not disappeared", file: file, line: line)
    }
    @discardableResult
    func waitToAppear(timeout: TimeInterval = kDefaultTimeout,
                      file: StaticString = #file,
                      line: UInt = #line) -> XCUIElement{
        XCTAssertTrue(waitForExistence(timeout: timeout),
                      "\(self) has not appeared", file: file, line: line)
        return self
    }
}
