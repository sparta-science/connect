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
                it("should not fail") {
                    expect { subject.beginInstallation(login: .init()) }.notTo(throwError())
                }
            }
        }
    }
}
