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
    
    func waitForHittable(timeout: TimeInterval = kDefaultTimeout,
                         file: StaticString = #file,
                         line: UInt = #line) -> XCUIElement{
        let hittablePredicate = NSPredicate(format: "hittable == true")
        let becameHittable = XCTNSPredicateExpectation(predicate: hittablePredicate, object: self)
        let waiter = XCTWaiter()
        XCTAssertEqual(waiter.wait(for: [becameHittable], timeout: timeout), .completed,
                       "\(self) has not became hittable", file: file, line: line)
        return self
    }
    
    func clickOnIt() {
        coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).click()
    }
    
    func hoverAnd() -> Self {
        hover()
        return self
    }
}
