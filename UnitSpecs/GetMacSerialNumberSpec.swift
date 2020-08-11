import Nimble
import Quick
import Testable

class GetMacSerialNumberSpec: QuickSpec {
    override func spec() {
        describe(getMacSerialNumber) {
            let serialNumberPattern = "\\w{12}"
            context("virtual machine serial number") {
                it("should match the same expression") {
                    expect("VMEH2wS0js7y").to(match(serialNumberPattern))
                }
            }
            it("should be a 12 character string of alphanumerics") {
                expect(getMacSerialNumber()).to(match(serialNumberPattern))
            }
        }
    }
}
