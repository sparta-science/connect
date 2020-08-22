import Nimble
import Quick
import SpartaConnect
@testable import USBDeviceSwift

class FakeMonitor: SerialDeviceMonitor {
    var didStartOnBackground: Bool?
    override func start() {
        didStartOnBackground = !Thread.isMainThread
    }
}

extension SerialDevice {
    init(_ device: ProductOfVendor) {
        self.init(path: "")
        vendorId = device.vendor
        productId = device.product
    }
    init(_ device: KnownDevice) {
        self.init(device.deviceIdentifier())
    }
}

class ForcePlateMonitorSpec: QuickSpec {
    override func spec() {
        describe(ForcePlateMonitor.self) {
            var subject: ForcePlateMonitor!
            var fake: FakeMonitor!
            var stub: ((String?) -> Void)!
            var center: NotificationCenter!
            beforeEach {
                fake = .init()
                center = .init()
                subject = .init(monitor: fake, center: center)
                stub = { _ in }
            }
            context(ForcePlateMonitor.start) {
                it("should start device monitor") {
                    subject.start(updating: stub)
                    expect(fake.didStartOnBackground).toEventually(beTrue(), timeout: 5)
                }
                it("should configure filter") {
                    subject.start(updating: stub)
                    expect(fake.filterDevices).notTo(beNil())
                }
                context("update") {
                    var device: SerialDevice!
                    beforeEach {
                        device = SerialDevice(path: "/dev/not-used")
                    }
                    context(Notification.Name.SerialDeviceRemoved) {
                        it("should be identified by name") {
                            waitUntil { done in
                                subject.start { deviceName in
                                    expect(deviceName).to(beNil())
                                    done()
                                }
                                center.post(name: .SerialDeviceRemoved,
                                            object: ["device": device])
                            }
                        }
                    }
                    context(Notification.Name.SerialDeviceAdded) {
                        func expectTo(beShownAs name: String,
                                      file: FileString = #file,
                                      line: UInt = #line) {
                            waitUntil { done in
                                subject.start { deviceName in
                                    expect(deviceName, file: file, line: line) == name
                                    done()
                                }
                                center.post(name: .SerialDeviceAdded,
                                            object: ["device": device])
                            }
                        }
                        context("device with name and no serial number") {
                            it("should be identified by name") {
                                device.name = "force plate"
                                expectTo(beShownAs: "force plate")
                            }
                        }
                        context("device with serial number and name") {
                            it("should be identified by serial number") {
                                device.name = "force plate"
                                device.serialNumber = "SerialNumber"
                                expectTo(beShownAs: "SerialNumber")
                            }
                        }
                        context("device with no serial number nor name") {
                            it("should be shown as connected") {
                                expectTo(beShownAs: "connected")
                            }
                        }
                    }
                }
                context(\SerialDeviceMonitor.filterDevices) {
                    var devices: [SerialDevice]!
                    beforeEach {
                        let validStm = SerialDevice(.stMicroelectronicsVirtualComPort)
                        let validFtdi = SerialDevice(.ftdiUsbUart)
                        let noVendor = SerialDevice(path: "")
                        let wrongProduct = SerialDevice(.init(vendor: 1, product: 2))
                        devices = [
                            validStm,
                            validFtdi,
                            noVendor,
                            wrongProduct
                        ]
                        subject.start(updating: stub)
                        devices = fake.filterDevices!(devices)
                    }
                    it("should only allow STM virtual com port and FTDI USB UART") {
                        expect(devices).to(haveCount(2))
                        devices.forEach {
                            expect(KnownDevice.allDevices).to(contain($0.deviceIdentifier()))
                        }
                    }
                }
            }
        }
    }
}
