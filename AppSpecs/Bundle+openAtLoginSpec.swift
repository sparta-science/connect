import Nimble
import Quick
import SpartaConnect
import NSBundle_LoginItem

class Bundle_OpenAtLoginSpec: QuickSpec {
    override func spec() {
        describe(Bundle.self) {
            var subject: Bundle!
            beforeEach {
                subject = .main
            }
            afterEach {
                subject.disableLoginItem()
            }
            context(\Bundle.openAtLogin) {
                it("should toggle login item") {
                    [true, false].forEach {
                        subject.openAtLogin = $0
                        expect(subject.isLoginItemEnabled()) == $0
                        expect(subject.openAtLogin) == $0
                    }
                }
            }
        }
    }
}
