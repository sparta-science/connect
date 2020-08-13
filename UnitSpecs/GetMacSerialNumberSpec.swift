import Nimble
import Quick
import Testable

class GetMacSerialNumberSpec: QuickSpec {
    override func spec() {
        describe(getMacSerialNumber) {
            var serialNumber: String!
            beforeEach {
                serialNumber = String(data: testData("serial-number.txt"),
                                      encoding: .ascii)
            }

            it("should match serial number") {
                expect(getMacSerialNumber() + "\n") == serialNumber
            }
        }
        describe(getPlatformExpertDevice(property:)) {
            context("invalid") {
                it("should be Unknown") {
                    expect(getPlatformExpertDevice(property: "invalid")) == "Unknown"
                }
            }
        }
    }
}
