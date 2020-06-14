import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let bundleHelper = BundleHelper(bundleId: "com.spartascience.SpartaConnect")
    let fileHelper = FileHelper()
    var removeMonitor: (()->Void)!
    func tempApp() -> XCUIApplication {
        XCUIApplication(url: tempUrl)
    }
    
    func clearCache() {
        bundleHelper.clearCache()
    }
    
    func hasDownloaded(fileName: String) -> NSPredicate {
        bundleHelper.find(file: fileName,
                          inCache: "org.sparkle-project.Sparkle/PersistentDownloads")
    }
    
    func prepare(for test: XCTestCase) {
        let openFirstTimeMonitor = test.addUIInterruptionMonitor(
            withDescription: "open first time"
        ) { alert -> Bool in
            print(alert)
            if alert.buttons["Show Application"].exists {
                XCTAssertTrue(alert.staticTexts[
                    "You are opening the application “SpartaConnect” for the first time. "
                        + "Are you sure you want to open this application?"
                ].exists)
                alert.buttons["Open"].click()
                return true
            }
            return false
        }
        removeMonitor = {test.removeUIInterruptionMonitor(openFirstTimeMonitor)}
        removeTempApp()
        fileHelper.copy(XCUIApplication().url, to: tempUrl)
        LaunchService.waitForAppToBeReadyForLaunch(at: tempUrl)
    }
    private func removeTempApp() {
        fileHelper.remove(url: tempUrl)
    }
    func cleanup() {
        removeMonitor()
        removeMonitor = nil
        removeTempApp()
    }
}

class MoveAppHelper: TempAppHelper {
    static func applications(home: URL) -> URL {
        home.appendingPathComponent("Applications")
    }
    // TODO: pz - refactor to fileHelper
    static func preferredApplicationsUrl() -> URL {
        let fileManager = FileManager.default

        let home = fileManager.homeDirectoryForCurrentUser
        let apps = applications(home: home)
        if let list = try? fileManager.contentsOfDirectory(at: apps, includingPropertiesForKeys: nil, options: []), list.count > 1 {
            return apps
        }
        return applications(home: URL(fileURLWithPath: "/"))
    }
    override init() {
        movedUrl = Self.preferredApplicationsUrl()
            .appendingPathComponent("SpartaConnect.app")
        super.init()
    }
    private let movedUrl: URL

    func movedApp() -> XCUIApplication {
        XCUIApplication(url: movedUrl)
    }
    override func cleanup() {
        super.cleanup()
        fileHelper.remove(url: movedUrl)
    }
}
