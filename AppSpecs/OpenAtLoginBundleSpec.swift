import Nimble
import Quick
import SpartaConnect
import NSBundle_LoginItem

class OpenAtLoginBundleSpec: QuickSpec {
    override func spec() {
        describe(OpenAtLoginBundle.self) {
            var subject: OpenAtLoginBundle!
            beforeEach {
                subject = .init()
            }
            fcontext(OpenAtLoginBundle.awakeAfter(using:)) {
                it("should be main bundle") {
                    expect(subject.awakeAfter(using: uninitialized())) === Bundle.main
                }
            }
        }
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
