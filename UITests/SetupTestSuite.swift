import XCTest

class SetupTestSuite: NSObject {
    static let shared = SetupTestSuite()

    static func startObserving() {
        let center = XCTestObservationCenter.shared
        center.addTestObserver(shared)
    }

    func stopVernalFalls() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
        process.arguments = ["bootout", "gui/\(getuid())/sparta_science.vernal_falls"]

        try! process.run()
        process.waitUntilExit()
    }

    func terminatePreviousInstances(bundleId: String) {
        NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).forEach {
            $0.terminate()
        }
    }
}

extension SetupTestSuite: XCTestObservation {
    func testBundleWillStart(_ testBundle: Bundle) {
        let bundleHelper = BundleHelper()
        terminatePreviousInstances(bundleId: bundleHelper.bundleId)
        bundleHelper.resetAppState()
        stopVernalFalls()
    }
}
