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

func wait(_ reason: String, timeout: Timeout = .test, until block:(_ done: @escaping () -> Void) -> Void) {
    let expectation = XCTestExpectation(description: reason)
    expectation.assertForOverFulfill = true
    block {
        expectation.fulfill()
    }
    XCTWaiter.wait(until: expectation, timeout: timeout, "should be " + reason)
}

extension XCTestCase {
    func waitForAppToStartAndTerminate(bundleId: String, timeout: Timeout) {
        var runningApp: NSRunningApplication!
        let startUpdate = keyValueObservingExpectation(for: NSWorkspace.shared, keyPath: "runningApplications") { _, changed -> Bool in
            if let apps = changed[NSKeyValueChangeKey.newKey] as? [NSRunningApplication],
                let found = apps.first(where: { $0.bundleIdentifier == bundleId }) {
                runningApp = found
                return true
            }
            return false
        }
        XCTWaiter.wait(until: startUpdate,
                       timeout: timeout,
                       "should start app: " + bundleId)
        XCTAssertFalse(runningApp.isTerminated, "should not terminate immediately")
        let updateComplete = keyValueObservingExpectation(for: runningApp!, keyPath: "isTerminated", expectedValue: true)
        XCTWaiter.wait(until: updateComplete, timeout: timeout, "should terminate: " + bundleId)
    }
}
