import Nimble
import Quick
import Testable

class TitleValueTransformerSpec: QuickSpec {
    override func spec() {
        describe(TitleValueTransformer.self) {
            describe(TitleValueTransformer.allowsReverseTransformation) {
                it("should be false") {
                    expect(TitleValueTransformer.allowsReverseTransformation()) == false
                }
            }
            describe(TitleValueTransformer.transformedValueClass) {
                it("should be a string") {
                    expect(TitleValueTransformer.transformedValueClass()) === NSString.self
                }
            }

            describe(TitleValueTransformer.transformedValue(_:)) {
                var subject: TitleValueTransformer!
                beforeEach {
                    subject = .init()
                }
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
