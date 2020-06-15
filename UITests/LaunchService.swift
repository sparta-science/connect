import XCTest

enum LaunchService {
    private static func isReadyToBeLaunched() -> NSPredicate {
        NSPredicate { object, _  in
            if let appUrl = object as? URL,
                let url = LSCopyDefaultApplicationURLForURL(appUrl as CFURL, .all, nil) {
                return (url.takeRetainedValue() as URL) == appUrl
            }
            return false
        }
    }

    static func waitForAppToBeReadyForLaunch(at url: URL) {
        let ready = XCTNSPredicateExpectation(predicate: isReadyToBeLaunched(),
                                              object: url)
        XCTWaiter().wait(for: [ready], timeout: Timeout.test.rawValue)
        let values = try! url.resourceValues(forKeys: [.quarantinePropertiesKey])
        XCTAssertNil(values.quarantineProperties, "should have no quarantine properties")
    }
}
