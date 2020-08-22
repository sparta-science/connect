import Testable
import USBDeviceSwift

public enum Identifier: Int {
    case stMicroelectronics = 0x0483
    case virtualComPort = 0x5740
    case ftdi = 0x0403
    case ftdiUsbUart = 0x6001
}

struct ProductOfVendor: Equatable {
    var vendor, product: Int
    init(vendor: Int, product: Int) {
        self.vendor = vendor
        self.product = product
    }
}

enum KnownDevices: CaseIterable {
    case stMicroelectronicsVirtualComPort
    case ftdiUsbUart
    func deviceIdentifier() -> ProductOfVendor {
        switch self {
        case .stMicroelectronicsVirtualComPort:
            return ProductOfVendor(vendor: 0x0483, product: 0x5740)
        case .ftdiUsbUart:
            return ProductOfVendor(vendor: 0x0403, product: 0x6001)
        }
    }
    static var allDevices: [ProductOfVendor] {
        allCases.map { $0.deviceIdentifier() }
    }
}

extension SerialDevice {
    func deviceIdentifier() -> ProductOfVendor {
        ProductOfVendor(vendor: vendorId ?? 0, product: productId ?? 0)
    }
}

public class ForcePlateMonitor {
    let serialDeviceMonitor: SerialDeviceMonitor
    let center: NotificationCenter
    var observers: [NSObjectProtocol] = []
    public init(monitor: SerialDeviceMonitor, center: NotificationCenter) {
        serialDeviceMonitor = monitor
        self.center = center
    }
}

extension ForcePlateMonitor: ForcePlateDetection {
    public func start(updating: @escaping (String?) -> Void) {
        serialDeviceMonitor.filterDevices = {
            $0.filter { KnownDevices.allDevices.contains($0.deviceIdentifier()) }
        }
        serialDeviceMonitor.filterDevices = {
            $0.filter {
                ($0.vendorId == Identifier.stMicroelectronics.rawValue
                    && $0.productId == Identifier.virtualComPort.rawValue)
                ||
                ($0.vendorId == Identifier.ftdi.rawValue
                    && $0.productId == Identifier.ftdiUsbUart.rawValue)
            }
        }
        let add = center.addObserver(forName: .SerialDeviceAdded, object: nil, queue: .main) { note in
            if let dict = note.object as? [String: SerialDevice],
                let plate = dict["device"] {
                updating(plate.serialNumber ?? plate.name ?? "connected")
            }
        }
        let remove = center.addObserver(forName: .SerialDeviceRemoved,
                                        object: nil,
                                        queue: .main) { _ in
                                            updating(nil)
        }
        observers = [add, remove]
        DispatchQueue.global(qos: .background).async {
            self.serialDeviceMonitor.start()
        }
    }
}
