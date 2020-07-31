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
                    TestDependency.register(Inject(uid_t(57), name: "user id"))
                    mockNotifier.send(state: .complete)
                }
                it("should launch service") {
                    expect(processLauncher.didRun) == ["/bin/launchctl", "bootstrap", "gui/57", testBundle.bundleURL.absoluteString]
                }
            }
            context("state changes to login") {
                var processLauncher: MockProcessLauncher!
                beforeEach {
                    processLauncher = .createAndInjectFactory()
                    TestDependency.register(Inject(testBundle.bundleURL, name: "installation url"))
                    TestDependency.register(Inject(uid_t(57), name: "user id"))
                    mockNotifier.send(state: .login)
                }
                fit("should stop service") {
                    expect(processLauncher.didRun) == ["/bin/launchctl", "bootout", "gui/57", testBundle.bundleURL.absoluteString]
                }
            }
        }
    }
}
