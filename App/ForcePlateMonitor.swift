import Testable
import USBDeviceSwift

public extension SerialDevice {
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
            $0.filter { KnownDevice.allDevices.contains($0.deviceIdentifier()) }
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
