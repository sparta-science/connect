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
                context("invalid url") {
                    var fileUrl: URL!
                    beforeEach {
                        fileUrl = testBundleUrl("expected-config.yml")
                    }
                    it("should throw not directory url") {
                        let notDirectory = NSError(domain: NSPOSIXErrorDomain, code: Int(ENOTDIR), userInfo: nil)
                        expect {
                            try subject.runShellScript(script: fileUrl, in: fileUrl)
                        }.to(throwError(notDirectory))
                    }
                }
            }

            describe(ProcessLauncher.run(command:args:in:)) {
                context("echo") {
                    it("should be successful") {
                        expect {
                            try subject.run(command: "echo", args: ["hello"], in: testBundleUrl("expected-config.yml"))
                        }.notTo(throwError())
                    }
                }
            }
        }
    }
}
