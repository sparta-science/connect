import Nimble
import Quick
import Testable

class LoginControllerSpec: QuickSpec {
    override func spec() {
        describe(LoginController.self) {
            var subject: LoginController!
            beforeEach {
                subject = .init()
            }
            context(LoginController.connectAction) {
                var mockInstaller: MockInstaller!
                beforeEach {
                    mockInstaller = .createAndInject()
                }
                it("should begin installation") {
                    subject.connectAction(.init())
                    expect(mockInstaller.didBegin) === subject.login
                }
            }
        }
    }
}
