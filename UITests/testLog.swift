import Foundation
import os
import XCTest

let testOSLog = OSLog(subsystem: "com.spartascience.SpartaConnect", category: "test")

func testLog(_ message: StaticString, _ args: CVarArg...) {
    os_log(message, log: testOSLog, type: .debug, args)
}
