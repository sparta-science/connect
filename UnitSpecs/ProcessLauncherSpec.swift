import Nimble
import Quick
import Testable

class ProcessLauncherSpec: QuickSpec {
    override func spec() {
        describe(ProcessLauncher.self) {
            var subject: ProcessLauncher!
            beforeEach {
                subject = .init()
            }
            describe(ProcessLauncher.runShellScript(script:in:)) {
                it("should report error when failing to launch") {
                    let notDirectory = NSError(domain: NSPOSIXErrorDomain, code: Int(ENOTDIR), userInfo: nil)
                    expect{
                        try subject.runShellScript(script: testBundleUrl("expected-config.yml"),
                                                    in: testBundleUrl("expected-config.yml"))
                    }.to(throwError(notDirectory))
                }
            }
        }
    }
}
