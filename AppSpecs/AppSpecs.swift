import Nimble
import Quick
import SpartaConnect

class AppDelegateSpec: QuickSpec {
    override func spec() {
        describe("AppDelegate") {
            var subject: AppDelegate!
            
            beforeEach {
                subject = .init()
            }
            
            context("NSApplicationDelegate") {
                it("should be object") {
                    expect(subject).to(beAKindOf(NSObject.self))
                }
            }
        }
    }
}
