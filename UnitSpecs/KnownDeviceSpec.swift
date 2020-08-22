import Nimble
import Quick
import Testable

class KnownDeviceSpec: QuickSpec {
    override func spec() {
        describe(KnownDevice.self) {
            context(KnownDevice.allDevices) {
                it("should have 2 devices") {
                    expect(KnownDevice.allDevices).to(haveCount(2))
                }
            }
        }
    }
}
