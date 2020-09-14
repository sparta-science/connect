import Quick
import Nimble
import Testable

class TitleValueTransformerSpec: QuickSpec {
    override func spec() {
        describe(TitleValueTransformer.self) {
            var subject: TitleValueTransformer!
            
            beforeEach {
                subject = .init()
            }
            describe(TitleValueTransformer.transformedValue(_:)) {
                context(true) {
                    it("should show offline title") {
                        expect(subject.transformedValue(true) as? String) == "Connect Offline to Local Sparta"
                    }
                }
                context(false) {
                    it("should show online title") {
                        expect(subject.transformedValue(false) as? String) == "Connect to Sparta Science"
                    }
                }
            }
        }
    }
}
