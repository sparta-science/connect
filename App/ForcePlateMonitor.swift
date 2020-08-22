import Testable
import USBDeviceSwift

public extension SerialDevice {
    func deviceIdentifier() -> ProductOfVendor {
        ProductOfVendor(vendor: vendorId ?? 0, product: productId ?? 0)
    }
}

public protocol Monitor {
    func add(when: Notification.Name, filtering: @escaping (_ obj: Any?) -> String?)
    func remove(when: Notification.Name)
}

extension NotificationCenter {
    func addObserver(_ name: Notification.Name,
                     block: @escaping (Any?) -> Void) -> NSObjectProtocol {
        addObserver(forName: name, object: nil, queue: .main) { note in
            block(note.object)
        }
    }
}

public class FPMonitor: Monitor {
    let center: NotificationCenter = .default
    var observers: [NSObjectProtocol] = []
    var name: String?
    public func add(when: Notification.Name, filtering: @escaping (Any?) -> String?) {
        observers.append(center.addObserver(when) { [weak self] object in
            self?.name = filtering(object) ?? "connected"
        })
    }
    public func remove(when: Notification.Name) {
        observers.append(center.addObserver(when) { [weak self] _ in
            self?.name = nil
        })
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
    public func startMonitor(_ monitor: Monitor) {
        serialDeviceMonitor.filterDevices = {
            $0.filter { KnownDevice.allDevices.contains($0.deviceIdentifier()) }
        }
        monitor.add(when: .SerialDeviceAdded) { object -> String? in
            guard let dict = object as? [String: SerialDevice],
                let plate = dict["device"] else {
                    return nil
            }
            return plate.serialNumber ?? plate.name
        }
        monitor.remove(when: .SerialDeviceRemoved)
        DispatchQueue.global(qos: .background).async {
            self.serialDeviceMonitor.start()
        }
    }
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
