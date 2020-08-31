import Nimble
import Quick
import Testable

class ServiceWatchdogSpec: QuickSpec {
    override func spec() {
        describe(ServiceWatchdog.self) {
            var subject: ServiceWatchdog!
            var mockNotifier: MockStateNotifier!
            var processLauncher: MockProcessLauncher!
            let fakeFolderUrl = URL(fileURLWithPath: "/fake/folder/just to have valid URL")
            let fakeScriptUrl = URL(fileURLWithPath: "/fake/script/location/that never runs.sh")
            var center: NotificationCenter!

            beforeEach {
                mockNotifier = .createAndInject()
                center = .init()
                TestDependency.register(Inject(center!))
                subject = .init()
                subject.awakeFromNib()
                processLauncher = .createAndInjectFactory()
            }
            context("state changes to completed") {
                beforeEach {
                    TestDependency.register(Inject(fakeFolderUrl, name: "installation url"))
                    TestDependency.register(Inject(fakeScriptUrl, name: "start script url"))
                }
                context("successfully") {
                    beforeEach {
                        mockNotifier.send(state: .complete)
                    }
                    it("should run start bash script in folder url") {
                        expect(processLauncher.didRun) == [
                            "/bin/bash",
                            fakeScriptUrl.path,
                            fakeFolderUrl.absoluteString]
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
                    TestDependency.register(Inject(fakeScriptUrl, name: "stop script url"))
                    mockNotifier.send(state: .login)
                }
                it("should run stop bash script in /tmp") {
                    expect(processLauncher.didRun) == [
                        "/bin/bash",
                        fakeScriptUrl.path,
                        "file://" + NSTemporaryDirectory()]
                }
            }
            context("application quits") {
                let willTerminate = NSApplication.willTerminateNotification

                beforeEach {
                    TestDependency.register(Inject(fakeScriptUrl, name: "stop script url"))
                }

                it("should run stop bash script in /tmp") {
                    center.post(name: willTerminate, object: nil)
                    expect(processLauncher.didRun) == [
                        "/bin/bash",
                        fakeScriptUrl.path,
                        "file://" + NSTemporaryDirectory()]
                }

                context("retain cycle") {
                    it("should not happen") {
                        weak var service: ServiceWatchdog?
                        autoreleasepool {
                            let newInstance = ServiceWatchdog()
                            service = newInstance
                            newInstance.awakeFromNib()
                            center.post(name: willTerminate, object: nil)
                        }
                        expect(service).to(beNil())
                    }
                }
            }
        }
    }
}
