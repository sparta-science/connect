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
                it("should show offline title when true") {
                    expect(subject.transformedValue(true) as? String) == "Connect Offline to Local Sparta"
                }
            }
        }
    }
}
