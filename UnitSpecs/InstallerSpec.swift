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
                    var downloader: MockDownloader!
                    beforeEach {
                        downloader = .createAndInject()
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
                        downloader.downloadedUrl = URL(fileURLWithPath: "/tmp/downloaded.txt")
                    }
                    func verify(file: String, at url: URL) {
                        let expectedPath = testBundleUrl(file).path
                        let equalContent = fileManager.contentsEqual(atPath: url.path,
                                                                     andPath: expectedPath)

                        expect(equalContent).to(beTrue(), description: "found: \(String(describing: try? String(contentsOf: url)))")
                    }
                    it("should transition to busy then to complete") {
                        subject.beginInstallation(login: request)
                        guard case .busy = subject.state else {
                            fail("should be busy")
                            return
                        }
                        expect(subject.state).toEventually(equal(.complete))
                        verify(file: "expected-config.yml", at: configUrl)
                    }
                    it("should download vernal falls archive") {
                        subject.beginInstallation(login: request)
                        expect(subject.state).toEventually(equal(.complete))
                        expect(downloader.didProvideReporting).notTo(beNil())
                        verify(file: "expected_vernal_falls.tar.gz",
                               at: installationUrl.appendingPathComponent("vernal_falls.tar.gz"))
                    }
                    it("should report downloding progress") {
                        subject.beginInstallation(login: request)
                        expect(subject.state).toEventually(equal(.complete))
                        subject.state = .busy(value: .init())
                        let progress = Progress()
                        downloader.didProvideReporting!(progress)
                        expect(subject.state) == .busy(value: progress)
                    }
                    it("should not become busy by pending callback of progressing downloads") {
                        subject.beginInstallation(login: request)
                        expect(subject.state).toEventually(equal(.complete))
                        downloader.didProvideReporting!(.init())
                        expect(subject.state) == .complete
                    }
                }
                context("server error") {
                    var errorReporter: MockErrorReporter!
                    beforeEach {
                        errorReporter = .createAndInject()
                    }
                    func beginLogin(urlString: String) {
                        let loginRequest = Init(LoginRequest()) {
                            $0.baseUrlString = urlString
                        }
                        subject.beginInstallation(login: loginRequest)
                    }
                    it("should report errors while connecting") {
                        beginLogin(urlString: "file://invalid-url")
                        expect(subject.state.progress()).toNot(beNil())
                        expect(subject.state).toEventually(equal(.login))
                        expect(errorReporter.didReport!.localizedDescription)
                            == "The requested URL was not found on this server."
                    }
                    it("should start progress, transition back to login and report error from server") {
                        beginLogin(urlString: testBundleUrl("server-error-response.json").absoluteString)
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
