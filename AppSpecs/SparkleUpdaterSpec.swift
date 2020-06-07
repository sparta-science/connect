import Nimble
import Quick
import Sparkle

class SparkleUpdaterSpec: QuickSpec {
    override func spec() {
        describe("updater") {
            var subject: SUUpdater!
            beforeEach {
                subject = SUUpdater.shared()
            }
            it("should be configured for automatic updates") {
                expect(subject.automaticallyDownloadsUpdates) == true
                expect(subject.automaticallyChecksForUpdates) == true
                expect(subject.feedURL.absoluteString) ==
                "https://github.com/sparta-science/connect/releases/latest/download/appcast.xml"
            }
            it("should check for updates within last 24 hours") {
                expect(subject.lastUpdateCheckDate.timeIntervalSinceNow) > -24 * 60 * 60
            }
        }
    }
}
