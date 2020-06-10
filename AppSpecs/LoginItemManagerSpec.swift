import Nimble
import Quick
import SpartaConnect
import NSBundle_LoginItem

class LoginItemManagerSpec: QuickSpec {
    override func spec() {
        describe("LoginItemManager") {
            var subject: LoginItemManager!
            
            beforeEach {
                subject = .init()
            }
            
            afterEach {
                Bundle.main.disableLoginItem()
            }
            
            context("openAtLogin") {
                it("should toggle login item") {
                    [true, false].forEach {
                        subject.openAtLogin = $0
                        expect(Bundle.main.isLoginItemEnabled()) == $0
                        expect(subject.openAtLogin) == $0
                    }
                }
            }
        }
    }
}
