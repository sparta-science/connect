import Nimble
import Quick
import SpartaConnect
import USBDeviceSwift

class FakeMonitor: SerialDeviceMonitor {
    var didStartOnBackground: Bool?
    override func start() {
        didStartOnBackground = !Thread.isMainThread
    }
    var filter: (([SerialDevice]) -> [SerialDevice])?
    override var filterDevices: (([SerialDevice]) -> [SerialDevice])? {
        get {
            filter
        }
        set {
            filter = newValue
        }
    }
}

class ForcePlateMonitorSpec: QuickSpec {
    override func spec() {
        describe(ForcePlateMonitor.self) {
            var subject: ForcePlateMonitor!
            var fake: FakeMonitor!
            beforeEach {
                fake = .init()
                subject = .init(monitor: fake)
            }
            context(ForcePlateMonitor.start) {
                it("should start device monitor") {
                    subject.start()
                    expect(fake.didStartOnBackground) == true
                }
                it("should configure filter") {
                    subject.start()
                    expect(fake.filterDevices).notTo(beNil())
                }
            }
        }
    }
}
