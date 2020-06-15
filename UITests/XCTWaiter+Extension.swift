import XCTest

extension XCTWaiter {
    @discardableResult
    static func wait(for expectation: XCTestExpectation,
                     timeout: Timeout = .test) -> XCTWaiter.Result {
        self.init().wait(for: [expectation], timeout: timeout.rawValue)
    }
    
    static func wait(until expectation: XCTestExpectation,
                     timeout: Timeout = .test,
                     _ reason: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
        XCTAssertEqual(wait(for: expectation, timeout: timeout),
                       .completed, reason, file: file, line: line)
    }
}
