import Combine
import Nimble
import Quick
import Testable

class InstallerSpec: QuickSpec {
    override func spec() {
        describe(Installer.self) {
            var subject: Installer!
            var stateContainer: MockStateContainer!
            var fileManager: FileManager!
            var defaults: UserDefaults!
            let installationUrl = URL(fileURLWithPath: "/tmp/test-installation")
            beforeEach {
                stateContainer = .createAndInject()
                subject = .init()
                fileManager = .default
                TestDependency.register(Inject(fileManager!))
                TestDependency.register(Inject(installationUrl, name: "installation url"))
            }
            func beginLogin(urlString: String) {
                TestDependency.register(Inject("irrelevant", name: "unique client id"))
                let loginRequest = Init(LoginRequest()) {
                    $0.baseUrlString = urlString
                }
                subject.beginInstallation(login: loginRequest)
            }
            func stubLogin(_ jsonFileName: String) {
                beginLogin(urlString: testBundleUrl(jsonFileName).absoluteString)
            }

            context(Installer.beginInstallation(login:)) {
                context("success") {
                    var downloader: MockDownloader!
                    func simulateSuccessLogin() {
                        stubLogin("successful-response-invalid-tar.json")
                    }
                    beforeEach {
                        downloader = .createAndInject()
                        let scriptUrl = testBundle.url(forResource: "install_vernal_falls", withExtension: "sh")!
                        TestDependency.register(Inject(scriptUrl, name: "installation script url"))

                        try? fileManager.removeItem(at: installationUrl)
                        expect(fileManager.fileExists(atPath: installationUrl.path)) == false
                        downloader.downloadedContentsUrl = testBundleUrl("tiny-valid.tar.gz")
                        defaults = .init()
                        TestDependency.register(Inject(defaults!))
                    }
                    func verify(file: String, at url: URL) {
                        let expectedPath = testBundleUrl(file).path
                        let equalContent = fileManager.contentsEqual(atPath: url.path,
                                                                     andPath: expectedPath)

                        expect(equalContent).to(beTrue(), description: "found: \(String(describing: try? String(contentsOf: url)))")
                    }
                    it("should transition to busy then to complete") {
                        simulateSuccessLogin()
                        expect(stateContainer.didTransition)
                            .toEventually(equal(["startReceiving()", "complete()"]))
                        let config = installationUrl.appendingPathComponent("vernal_falls_config.yml")
                        verify(file: "expected-config.yml", at: config)
                    }
                    it("should download vernal falls archive") {
                        simulateSuccessLogin()
                        expect(stateContainer.didTransition).toEventually(contain("complete()"))
                        expect(downloader.didProvideReporting).notTo(beNil())
                        verify(file: "tiny-valid.tar.gz",
                               at: installationUrl.appendingPathComponent("vernal_falls.tar.gz"))
                    }
                    it("should install vernal falls and save the org name") {
                        defaults.removeObject(forKey: "org.name")
                        simulateSuccessLogin()
                        expect(stateContainer.didTransition).toEventually(contain("complete()"))
                        let unTaredContents = try? String(contentsOf: installationUrl.appendingPathComponent("vernal_falls/small-file.txt"))
                        expect(unTaredContents) == ""
                        expect(defaults.value(forKey: "org.name") as? String) == "Training Ground"
                    }
                    context("download progress") {
                        var progressReporter: Progressing!
                        beforeEach {
                            expect(downloader.didProvideReporting).to(beNil())
                            simulateSuccessLogin()
                            expect(stateContainer.didTransition).toEventually(contain("complete()"))
                            progressReporter = downloader.didProvideReporting
                        }
                        it("should set state to busy with the progress of download") {
                            let progress = Progress()
                            progressReporter(progress)
                            expect(stateContainer.didProgress) == progress
                        }
                    }
                    context("installation failure") {
                        var errorReporter: MockErrorReporter!
                        beforeEach {
                            errorReporter = .createAndInject()
                            let invalidArchive = testBundleUrl("expected-config.yml")
                            downloader.downloadedContentsUrl = invalidArchive
                        }
                        it("should report error and status code") {
                            simulateSuccessLogin()
                            expect(stateContainer.didTransition).toEventually(equal(["startReceiving()", "reset()"]))
                            let reportedError = errorReporter.didReport as? LocalizedError
                            expect(reportedError?.localizedDescription)
                                == "Failed with exit code: 1"
                            expect(reportedError?.recoverySuggestion)
                                == "tar: Error opening archive: Unrecognized archive format\n"
                        }
                    }
                }
                context("server error") {
                    var errorReporter: MockErrorReporter!
                    beforeEach {
                        errorReporter = .createAndInject()
                    }
                    it("should report errors while connecting") {
                        beginLogin(urlString: "file://invalid-url")
                        expect(stateContainer.didTransition).toEventually(equal(["startReceiving()", "reset()"]))
                        expect(errorReporter.didReport!.localizedDescription)
                            == "The requested URL was not found on this server."
                    }
                    it("should start progress, transition back to login and report error from server") {
                        stubLogin("server-error-response.json")
                        expect(stateContainer.didTransition).toEventually(equal(["startReceiving()", "reset()"]))
                        let reportedError = errorReporter.didReport as? LocalizedError
                        expect(reportedError?.localizedDescription)
                            == "Server Error"
                        expect(reportedError?.recoverySuggestion)
                            == "Email and password are not valid"
                    }
                }
            }
            context(Installer.uninstall) {
                it("should transition to login") {
                    subject.uninstall()
                    expect(stateContainer.didTransition) == ["reset()"]
                }
                context("application support subfolder") {
                    beforeEach {
                        try! fileManager.createDirectory(at: installationUrl,
                                                         withIntermediateDirectories: true)
                    }
                    it("should be removed") {
                        subject.uninstall()
                        expect(fileManager.fileExists(atPath: installationUrl.path)) == false
                    }
                }
                context("download started") {
                    var downloader: WaitingToBeCancelled!
                    beforeEach {
                        defaults = .init()
                        TestDependency.register(Inject(defaults!))
                        downloader = .createAndInject()
                        waitUntil { downloadRequest in
                            downloader.startDownloading = downloadRequest
                            stubLogin("successful-response-valid-archive.json")
                        }
                    }
                    it("should cancel download") {
                        subject.uninstall()
                        expect(downloader.wasCancelled) == true
                    }
                }
            }
        }
    }
}
