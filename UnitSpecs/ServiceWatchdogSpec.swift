import Nimble
import Quick
import Testable

class ServiceWatchdogSpec: QuickSpec {
    override func spec() {
        describe(ServiceWatchdog.self) {
            var subject: ServiceWatchdog!
            var mockNotifier: MockStateNotifier!
            var processLauncher: MockProcessLauncher!
            let folderUrl = URL(fileURLWithPath: "/tmp/some folder")

            beforeEach {
                mockNotifier = .createAndInject()
                subject = .init()
                expect(subject).notTo(beNil())
                processLauncher = .createAndInjectFactory()
                TestDependency.register(Inject(uid_t(57), name: "user id"))
            }
            context("state changes to completed") {
                beforeEach {
                    TestDependency.register(Inject(folderUrl, name: "installation url"))
                }
                context("successfully") {
                    beforeEach {
                        mockNotifier.send(state: .complete)
                    }
                    it("should launch service") {
                        expect(processLauncher.didRun) == [
                            "/bin/launchctl",
                            "bootstrap",
                            "gui/57",
                            "sparta_science.vernal_falls.plist",
                            folderUrl.absoluteString, "37"]
                    }
                }
                context("unsuccessfully") {
                    var mockErrorReporter: MockErrorReporter!
                    var failingLauncher: MockErrorProcessLauncher!
                    beforeEach {
                        mockErrorReporter = .createAndInject()
                        failingLauncher = .createAndInjectFactory()
                        failingLauncher.error = NSError(domain: "test",
                                                        code: 26,
                                                        userInfo: [NSLocalizedDescriptionKey: "failed to start"])
                        mockNotifier.send(state: .complete)
                    }
                    it("should report the error") {
                        expect(mockErrorReporter.didReport?.localizedDescription) ==  "failed to start"
                    }
                }
            }
            context("state changes to login") {
                beforeEach {
                    mockNotifier.send(state: .login)
                }
                it("should stop service ignoring benign errors") {
                    // see: https://github.com/sparta-science/connect/wiki/Launch-Control#common-errors
                    expect(processLauncher.didRun) == [
                        "/bin/launchctl",
                        "bootout",
                        "gui/57/sparta_science.vernal_falls",
                        "file:///tmp/", "3", "36"]
                }
            }
            context("application quits") {
                var center: NotificationCenter!
                let willTerminate = NSApplication.willTerminateNotification

                beforeEach {
                    center = .init()
                    TestDependency.register(Inject(center!))
                    subject.awakeFromNib()
                }

                it("should bootout") {
                    center.post(name: willTerminate, object: nil)
                    expect(processLauncher.didRun).to(contain("bootout"))
                }
            }
        }
    }
}
