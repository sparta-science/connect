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
                    [false, true].forEach {
                        subject.openAtLogin = $0
                        expect(Bundle.main.isLoginItemEnabled())
                            .toEventually(equal($0),
                                          timeout: 20,
                                          pollInterval: 2)
                        expect(subject.openAtLogin) == $0
                    }
                }
            }
        }
    }
}
