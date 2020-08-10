import Nimble
import Quick
import Sparkle

class SparkleUpdaterSpec: QuickSpec {
    override func spec() {
        describe(SUUpdater.shared) {
            var subject: SUUpdater!
            beforeEach {
                subject = SUUpdater.shared()
            }
            it("should be configured for automatic updates") {
                expect(subject.automaticallyDownloadsUpdates) == true
                expect(subject.automaticallyChecksForUpdates) == true
                expect(subject.feedURL.absoluteString) ==
                    "https://sparta-test-resources.s3-us-west-1.amazonaws.com/sparta-connect/appcast.xml"
            }
            it("should check for updates within last 24 hours") {
                expect(subject.lastUpdateCheckDate.timeIntervalSinceNow) > -24 * 60 * 60
            }
        }
    }
}
