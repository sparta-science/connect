import XCTest

enum LaunchService {
    private static func isReadyToBeLaunched() -> NSPredicate {
        let workspace = NSWorkspace.shared
        return NSPredicate { object, _  in
            if let appUrl = object as? URL,
                let url = workspace.urlForApplication(toOpen: appUrl) {
                NSLog("url:\(url), appUrl: \(appUrl)")
                return url == appUrl
            }
            NSLog("no app for url:\(object)")
            return false
        }
    }

    static func waitForAppToBeReadyForLaunch(at url: URL) {
        let workspace = NSWorkspace.shared
        let fileType = try! workspace.type(ofFile: url.path)
        XCTAssertEqual(kUTTypeApplicationBundle as String, fileType)
        let ready = XCTNSPredicateExpectation(predicate: isReadyToBeLaunched(),
                                              object: url)
        XCTWaiter.wait(until: ready, timeout: .install,
                       "app is not ready for launch at: \(url)")
        let values = try! url.resourceValues(forKeys: [.quarantinePropertiesKey])
        XCTAssertNil(values.quarantineProperties, "should have no quarantine properties")
    }
}
