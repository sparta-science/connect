import XCTest

enum RareEvent: String, CaseIterable {
    case firstTimeOpenAlert
}

class RareEventMonitor: NSObject {
    var successful = true
    static let shared = RareEventMonitor()

    static func log(_ event: RareEvent) {
        shared.logEvent(event)
    }

    static func startMonitoring() {
        let center = XCTestObservationCenter.shared
        center.addTestObserver(shared)
    }

    var recordedEvents = [RareEvent]()
    func logEvent(_ event: RareEvent) {
        recordedEvents.append(event)
    }
    func counts() -> [String: Int] {
        let empty = RareEvent.allCases.map { ($0.rawValue, 0) }
        let combined = empty + recordedEvents.map { ($0.rawValue, 1) }
        return Dictionary(combined,
                   uniquingKeysWith: +)
    }
    func spartaMetrics() -> [String: String] {
        var values = counts().mapValues { $0.description }
        var commit = "unknown"
        if let sha = try? String(contentsOfFile: "/tmp/git-commit-sha.txt", encoding: .ascii) {
            commit = sha.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        values["time"] = Date().timeIntervalSinceReferenceDate.description
        values["host"] = ProcessInfo.processInfo.environment["GITHUB_WORKFLOW"] ?? Host.current().localizedName!
        values["commit"] = commit
        return values
    }
    func formKey(dataKey: String) -> String {
        [
            "host": "entry.1585459658",
            "time": "entry.60160137",
            "commit": "entry.634580662",
            "firstTimeOpenAlert": "entry.682716004"
        ][dataKey]!
    }
    func createForm(data: [String: String]) -> String {
        Init(URLComponents()) {
            $0.queryItems = data.map { URLQueryItem(name: formKey(dataKey: $0), value: $1) }
        }.percentEncodedQuery!
    }
    func writeSpartaMetrics() {
        let formUrl = URL(fileURLWithPath: "/tmp/sparta-ui-test-metrics-url-encoded-form.txt")
        try! createForm(data: spartaMetrics()).write(to: formUrl,
                                                     atomically: true,
                                                     encoding: .ascii)
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

struct AwsMetric: Codable {
    let MetricName: String
    let Value: Int
}

extension RareEventMonitor: XCTestObservation {
    func testBundleDidFinish(_ testBundle: Bundle) {
        if successful {
            reportMetrics()
            if !recordedEvents.isEmpty {
                print("warning: there are some events: \(recordedEvents.map { $0.rawValue })")
                try! "detected events: \(recordedEvents)".write(toFile: "/tmp/events-detected-during-ui-tests.txt", atomically: true, encoding: .ascii)
            }
        } else {
            print("error: skipping metrics due to failures")
        }
    }
    func testSuiteDidFinish(_ testSuite: XCTestSuite) {
        if testSuite.testRun?.hasSucceeded != true {
            successful = false
        }
    }
}
