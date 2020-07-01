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
            context(Installer.beginInstallation) {
                it("should transition to busy") {
                    subject.beginInstallation(login: .init())
                    waitUntil { done in
                        if case .busy = subject.state {
                            done()
                        }
                    }
                }
            }
        }
    }
}
