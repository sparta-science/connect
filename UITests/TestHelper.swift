import XCTest

func lastErrorDescription() -> String {
    String(cString: strerror(errno))
}

func verifySuccess(_ result: Int32) {
    XCTAssertEqual(noErr, result, lastErrorDescription())
}

func verifyNoError(_ error: Error?,
            _ message: @autoclosure () -> String = "",
            file: StaticString = #file,
            line: UInt = #line) {
    XCTAssertNil(error, message(), file: file, line: line)
}

func verify(_ condition: Bool,
            _ message: @autoclosure () -> String = "",
            file: StaticString = #file,
            line: UInt = #line) {
    XCTAssertTrue(condition, message(), file: file, line: line)
}

func wait(_ reason:String, until block:(_ done: @escaping ()->Void)->Void) {
    let expectation = XCTestExpectation(description: reason)
    expectation.assertForOverFulfill = true
    block {
        expectation.fulfill()
    }
    XCTWaiter.wait(until: expectation, "should be " + reason)
}
