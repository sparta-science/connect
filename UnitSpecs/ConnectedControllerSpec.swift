import Nimble
import Quick
import Testable

class ConnectedControllerSpec: QuickSpec {
    override func spec() {
        describe(ConnectedController.self) {
            context(ConnectedController.disconnect(_:)) {
                var mockInstaller: MockInstaller!
                beforeEach {
                    mockInstaller = .createAndInject()
                }
                it("should uninstall") {
                    ConnectedController().disconnect(.init())
                    expect(mockInstaller.didCall) == "uninstall()"
                }
            }
        }
    }
}
