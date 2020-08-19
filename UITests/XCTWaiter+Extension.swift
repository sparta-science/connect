import XCTest

extension XCTWaiter.Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .completed:
            return "completed"
        case .timedOut:
            return "timedOut"
        case .incorrectOrder:
            return "incorrectOrder"
        case .invertedFulfillment:
            return "invertedFulfillment"
        case .interrupted:
            return "interrupted"
        @unknown default:
            return "unknown"
        }
    }
}

extension XCTWaiter {
    @discardableResult
    static func wait(for expectation: XCTestExpectation,
                     timeout: Timeout = .test) -> XCTWaiter.Result {
        Self().wait(for: [expectation], timeout: timeout.rawValue)
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
