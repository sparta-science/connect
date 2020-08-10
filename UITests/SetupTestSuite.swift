import XCTest

class SetupTestSuite: NSObject {
    var successful = true
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
}

extension SetupTestSuite: XCTestObservation {
    func testBundleWillStart(_ testBundle: Bundle) {
        stopVernalFalls()
    }
}
