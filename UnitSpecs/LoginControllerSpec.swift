import Nimble
import Quick
import Testable

class LoginControllerSpec: QuickSpec {
    override func spec() {
        describe(LoginController.self) {
            var subject: LoginController!
            beforeEach {
                subject = .init()
            }
            context(LoginController.connectAction) {
                var mockInstaller: MockInstaller!
                var mockLocator: MockLocator!
                beforeEach {
                    mockInstaller = .createAndInject()
                    mockLocator = .createAndInject()
                }
                it("should begin installation") {
                    subject.connectAction(NSButton())
                    expect(mockInstaller.didBegin) === mockLocator.fakeLoginRequest
                }
            }
            context(LoginController.awakeFromNib) {
                beforeEach {
                    class MockProcessInfo: ProcessInfo {
                        override var environment: [String: String] {
                            [
                                "debug-email": "diminution@evocative.com",
                                "debug-password": "Loquacious",
                                "debug-backend": "Obsequious"
                            ]
                        }
                    }
                    TestDependency.register(
                        Inject(MockProcessInfo() as ProcessInfo)
                    )
                }
                it("should set login from build environment") {
                    subject.awakeFromNib()
                    expect(subject.login.environment) == "Obsequious"
                    expect(subject.login.username) == "diminution@evocative.com"
                    expect(subject.login.password) == "Loquacious"
                }
            }
        }
    }
}
