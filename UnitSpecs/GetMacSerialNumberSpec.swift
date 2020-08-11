import Nimble
import Quick
import Testable

class GetMacSerialNumberSpec: QuickSpec {
    override func spec() {
        describe(getMacSerialNumber) {
            it("returns a string of 12 characters") {
                expect(getMacSerialNumber()).to(haveCount(12))
            }
        }
    }
}
