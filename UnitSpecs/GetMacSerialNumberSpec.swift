import Nimble
import Quick
import Testable

class GetMacSerialNumberSpec: QuickSpec {
    override func spec() {
        describe(getMacSerialNumber) {
            var subject: String!
            beforeEach {
                subject = getMacSerialNumber()
            }
            it("returns a string of 12 characters") {
                expect(subject).to(haveCount(12))
            }
            it("the 'subject' should be alphanumeric characters") {
                expect(subject.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted)).to(beNil())
            }
            it("should be upper case") {
                expect(subject.uppercased()) == subject
            }
        }
    }
}
