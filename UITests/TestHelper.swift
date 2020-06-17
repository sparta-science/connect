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

extension XCTestCase {
    func waitForAppToStartAndTerminate(bundleId: String) {
        var runningAutoUpdate: NSRunningApplication?
        let startUpdate = keyValueObservingExpectation(for: NSWorkspace.shared, keyPath: "runningApplications") { (value, changed) -> Bool in
            if let apps = changed[NSKeyValueChangeKey.newKey] as? [NSRunningApplication],
                let sparkle = apps.first(where: { $0.bundleIdentifier == bundleId }) {
                runningAutoUpdate = sparkle
                return true
            }
            return false
        }
        wait(for: [startUpdate], timeout: Timeout.install.rawValue)
        if let update = runningAutoUpdate, update.isTerminated != true {
            let updateComplete = keyValueObservingExpectation(for: update, keyPath: "isTerminated", expectedValue: true)
            if update.isTerminated {
                updateComplete.fulfill()
            } else {
                wait(for: [updateComplete], timeout: Timeout.install.rawValue)
            }
        }
    }
}
