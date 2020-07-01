import Nimble
import Quick
import Testable

class ProgressControllerSpec: QuickSpec {
    override func spec() {
        describe(ProgressController.self) {
            var subject: ProgressController!
            beforeEach {
                subject = .init()
            }
            context(ProgressController.cancelInstallation(_:)) {
                var mockInstaller: MockInstaller!
                beforeEach {
                    mockInstaller = .createAndInject()
                }
                it("should tell installer to cancel installation") {
                    subject.cancelInstallation(.init())
                    expect(mockInstaller.didCall) == "cancelInstallation()"
                }
            }
        }
    }
}
