import Nimble
import Quick
import Testable

class GetMacSerialNumberSpec: QuickSpec {
    override func spec() {
        describe(getMacSerialNumber) {
            it("should be a 12 character string of uppercase alphanumerics") {
                expect(getMacSerialNumber()).to(match("[A-Z0-9]{12}"))
            }
        }
    }
}
