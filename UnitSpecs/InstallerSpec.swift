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
            context(Installer.makeRequest(_:)) {
                let installationUrl = URL(fileURLWithPath: "/tmp/test-installation")
                beforeEach {
                    TestDependency.register(Inject(FileManager.default))
                    TestDependency.register(Inject(installationUrl, name: "installation url"))
                }
                context("success") {
                    var configUrl: URL!
                    var request: URLRequest!
                    let fileManager = FileManager.default
                    beforeEach {
                        configUrl = installationUrl
                            .appendingPathComponent("vernal_falls_config.yml")
                        try? fileManager.removeItem(at: configUrl)
                        expect(fileManager.fileExists(atPath: configUrl.path)) == false
                        request = .init(url: testBundleUrl("successful-response.json"))
                    }
                    it("should transition to complete") {
                        subject.makeRequest(request)
                        expect(subject.state).toEventually(equal(.complete))
                        let expectedPath = testBundleUrl("expected-config.yml").path
                        let equalContent = fileManager.contentsEqual(atPath: configUrl.path,
                                                                     andPath: expectedPath)
                        expect(equalContent) == true
                    }
                }
                context("server error") {
                    var request: URLRequest!
                    var errorReporter: MockErrorReporter!
                    beforeEach {
                        errorReporter = .createAndInject()
                        request = .init(url: testBundleUrl("server-error-response.json"))
                    }
                    it("should start progress, transition back to login and report error") {
                        subject.makeRequest(request)
                        expect(subject.state.progress()).toNot(beNil())
                        expect(subject.state).toEventually(equal(.login))
                        expect(errorReporter.didReport!.localizedDescription)
                            == "Email and password are not valid"
                    }
                }
            }
            context(Installer.beginInstallation) {
                it("should transition to busy") {
                    subject.beginInstallation(login: .init())
                    waitUntil { done in
                        if case .busy = subject.state {
                            done()
                        }
                    }
                }
                afterEach {
                    subject.cancelInstallation()
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
