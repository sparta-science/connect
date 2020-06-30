import Nimble
import Quick
import Testable

class ProgressControllerSpec: QuickSpec {
    override func spec() {
        describe(ProgressController.self) {
            context(ProgressController.cancelInstallation(_:)) {
                it("should not crash") {
                    expect {
                        ProgressController().cancelInstallation(.init())
                    }.notTo(throwError())
                }
            }
        }
    }
}
