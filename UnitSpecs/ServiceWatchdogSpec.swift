import Nimble
import Quick
import Testable

class ServiceWatchdogSpec: QuickSpec {
    override func spec() {
        describe(ServiceWatchdog.self) {
            var subject: ServiceWatchdog!
            var mockNotifier: MockStateNotifier!

            beforeEach {
                mockNotifier = .createAndInject()
                subject = .init()
                expect(subject).notTo(beNil())
            }
            context("state changes to completed") {
                var processLauncher: MockProcessLauncher!
                beforeEach {
                    processLauncher = .createAndInjectFactory()
                    TestDependency.register(Inject(testBundle.bundleURL, name: "installation url"))
                    mockNotifier.send(state: .complete)
                }
                it("should launch service") {
                    expect(processLauncher.didRun) == ["/bin/launchctl", "bootstrap", testBundle.bundleURL.absoluteString]
                }
            }
            context("state changes to login") {
                it("should stop service") {
                }
            }
        }
    }
}
