import Nimble
import Quick
import SpartaConnect
import NSBundle_LoginItem

class LoginItemManagerSpec: QuickSpec {
    override func spec() {
        describe("LoginItemManager") {
            var subject: LoginItemManager!
            var bundle: Bundle!
            
            beforeEach {
                bundle = .main
                subject = .init()
            }
            
            afterEach {
                bundle.disableLoginItem()
            }
            
            context("openAtLogin") {
                it("should toggle login item") {
                    [true, false].forEach {
                        subject.openAtLogin = $0
                        expect(bundle.isLoginItemEnabled()) == $0
                        expect(subject.openAtLogin) == $0
                    }
                }
            }
        }
    }
}
