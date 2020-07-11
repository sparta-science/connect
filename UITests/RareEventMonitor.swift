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
    func awsMetrics() -> [AwsMetric] {
        counts().map { AwsMetric(MetricName: $0, Value: $1) }
    }
    func writeAwsMetrics() {
        try! JSONEncoder().encode(awsMetrics())
            .write(to: URL(fileURLWithPath: "/tmp/aws-ui-test-metrics.json"))
    }
    func metrics() -> [Metric] {
        counts().map { Metric(name: $0, value: $1) }
    }
    func writeMetrics() {
        try! JSONEncoder().encode(metrics())
            .write(to: URL(fileURLWithPath: "/tmp/ui-test-metrics.json"))
    }
    func writeCounts() {
        let fileUrl = URL(fileURLWithPath: "/tmp/rare-test-events.plist")
        NSDictionary(dictionary: counts())
            .write(to: fileUrl, atomically: true)
    }
}

struct AwsMetric: Codable {
    let MetricName: String
    let Value: Int
}

struct Metric: Codable {
    let name: String
    let value: Int
}

extension RareEventMonitor: XCTestObservation {
    func testSuiteWillStart(_ testSuite: XCTestSuite) {
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.appIsNotReadyToBeLaunched)
        events.append(.uiagentWarning)
        writeMetrics()
        writeAwsMetrics()
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
