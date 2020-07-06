import Combine
import Nimble
import Quick
import Testable

class InstallerSpec: QuickSpec {
    override func spec() {
        describe(Installer.self) {
            var subject: Installer!
            beforeEach {
                subject = .init()
            }
            context(Installer.beginInstallation(login:)) {
                let installationUrl = URL(fileURLWithPath: "/tmp/test-installation")
                context("success") {
                    beforeEach {
                        TestDependency.register(Inject(FileManager.default))
                        TestDependency.register(Inject(installationUrl, name: "installation url"))
                    }
                    var configUrl: URL!
                    var request: LoginRequest!
                    let fileManager = FileManager.default
                    beforeEach {
                        configUrl = installationUrl
                            .appendingPathComponent("vernal_falls_config.yml")
                        try? fileManager.removeItem(at: configUrl)
                        expect(fileManager.fileExists(atPath: configUrl.path)) == false
                        request = Init(.init()) {
                            $0?.baseUrlString = testBundleUrl("successful-response.json").absoluteString
                        }
                    }
                    it("should transition to busy then to complete") {
                        subject.beginInstallation(login: request)
                        guard case .busy = subject.state else {
                            fail("should be busy")
                            return
                        }
                        expect(subject.state).toEventually(equal(.complete))
                        let expectedPath = testBundleUrl("expected-config.yml").path
                        let equalContent = fileManager.contentsEqual(atPath: configUrl.path,
                                                                     andPath: expectedPath)
                        expect(equalContent) == true
                    }
                }
                context("server error") {
                    var errorReporter: MockErrorReporter!
                    beforeEach {
                        errorReporter = .createAndInject()
                    }
                    // TODO: refactor duplication
                    it("should report errors while connecting") {
                        let loginRequest = Init(LoginRequest()) {
                            $0.baseUrlString = "file://invalid-url"
                        }

                        subject.beginInstallation(login: loginRequest)
                        expect(subject.state.progress()).toNot(beNil())
                        expect(subject.state).toEventually(equal(.login))
                        expect(errorReporter.didReport!.localizedDescription)
                            == "The requested URL was not found on this server."
                    }
                    it("should start progress, transition back to login and report error from server") {
                        let loginRequest = Init(LoginRequest()) {
                            $0.baseUrlString = testBundleUrl("server-error-response.json").absoluteString
                        }

                        subject.beginInstallation(login: loginRequest)
                        expect(subject.state.progress()).toNot(beNil())
                        expect(subject.state).toEventually(equal(.login))
                        expect(errorReporter.didReport!.localizedDescription)
                            == "Email and password are not valid"
                    }
                }
            }
            context(Installer.cancelInstallation) {
                beforeEach {
                    subject.state = .busy(value: .init())
                }
                it("should transition to login") {
                    subject.cancelInstallation()
                    expect(subject.state) == .login
                }
            }
            context(Installer.uninstall) {
                beforeEach {
                    subject.state = .complete
                }
                it("should transition to login") {
                    subject.uninstall()
                    expect(subject.state) == .login
                }
            }
        }
    }
}
