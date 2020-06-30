import Nimble
import Quick
import Testable

class ConnectedControllerSpec: QuickSpec {
    override func spec() {
        describe(ConnectedController.self) {
            context(ConnectedController.disconnect(_:)) {
                it("should not crash") {
                    expect { ConnectedController().dismiss(nil) }.notTo(throwError())
                }
            }
        }
    }
}
