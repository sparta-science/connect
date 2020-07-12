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
    func spartaMetrics() -> SpartaMetrics {
        let values = counts().map { [$0.key, $0.value.description] }.sorted { $0[0] < $1[0] }
        var commit = "unknown"
        if let sha = try? String(contentsOfFile: "/tmp/git-commit-sha.txt", encoding: .ascii) {
            commit = sha.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let properties = [
            ["time", Date().timeIntervalSinceReferenceDate.description],
            ["host", Host.current().localizedName!],
            ["commit", commit]
        ]
        return SpartaMetrics(values: properties + values)
    }
    func writeSpartaMetrics() {
        try! JSONEncoder().encode(spartaMetrics())
            .write(to: URL(fileURLWithPath: "/tmp/sparta-ui-test-metrics.json"))
    }
    func awsMetrics() -> [AwsMetric] {
        counts().map { AwsMetric(MetricName: $0, Value: $1) }
    }
    func writeAwsMetrics() {
        try! JSONEncoder().encode(awsMetrics())
            .write(to: URL(fileURLWithPath: "/tmp/aws-ui-test-metrics.json"))
    }
    func writeCounts() {
        let fileUrl = URL(fileURLWithPath: "/tmp/rare-test-events.plist")
        NSDictionary(dictionary: counts())
            .write(to: fileUrl, atomically: true)
    }
    func reportMetrics() {
        writeSpartaMetrics()
        writeAwsMetrics()
        writeCounts()
    }
}

struct SpartaMetrics: Codable {
    let majorDimension = "COLUMNS"
    let values: [[String]]
}

struct AwsMetric: Codable {
    let MetricName: String
    let Value: Int
}

extension RareEventMonitor: XCTestObservation {
    func testSuiteDidFinish(_ testSuite: XCTestSuite) {
        if testSuite.testRun?.hasSucceeded == true {
            reportMetrics()
            if !events.isEmpty {
                print("warning: there are some events")
            }
        }
    }
}
