import XCTest

enum RareEvent: String, CaseIterable {
    case uiagentWarning
    case firstTimeOpenAlert
    case hadToRetryLaunching
    case appIsNotReadyToBeLaunched
}

class RareEventMonitor: NSObject {
    static let shared = RareEventMonitor()

    static func log(_ event: RareEvent) {
        shared.logEvent(event)
    }

    static func startMonitoring() {
        let center = XCTestObservationCenter.shared
        center.addTestObserver(shared)
    }

    var events = [RareEvent]()
    func logEvent(_ event: RareEvent) {
        events.append(event)
    }
    func counts() -> [String: Int] {
        let empty = RareEvent.allCases.map { ($0.rawValue, 0) }
        let combined = empty + events.map { ($0.rawValue, 1) }
        return Dictionary(combined,
                   uniquingKeysWith: +)
    }
    func writeCounts() {
        let fileUrl = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("rare-test-events.plist")
        NSDictionary(dictionary: counts())
            .write(to: fileUrl, atomically: true)
    }
}

extension RareEventMonitor: XCTestObservation {
    func testSuiteWillStart(_ testSuite: XCTestSuite) {
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.uiagentWarning)
        writeCounts()
    }
    func testSuiteDidFinish(_ testSuite: XCTestSuite) {
        if testSuite.testRun?.hasSucceeded == true {
            writeCounts()
            if !events.isEmpty {
                print("warning: there are some events")
            }
        }
    }
}
