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
            describe(ProcessLauncher.runShellScript(script:)) {
                // TODO:
                it("should report error when failing to launch") {
                    try! subject.runShellScript(script: testBundleUrl("expected-config.yml"))
                }
            }
        }
    }
}
