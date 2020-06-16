import XCTest

func lastErrorDescription() -> String {
    String(cString: strerror(errno))
}

func verifySuccess(_ result: Int32) {
    XCTAssertEqual(noErr, result, lastErrorDescription())
}

func verify(_ condition: Bool,
            _ message: @autoclosure () -> String = "",
            file: StaticString = #file,
            line: UInt = #line) {
    XCTAssertTrue(condition, message(), file: file, line: line)
}
