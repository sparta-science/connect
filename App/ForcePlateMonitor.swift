import Foundation
import USBDeviceSwift

protocol Starting {
    func start()
}

public class ForcePlateMonitor {
    let serialDeviceMonitor: SerialDeviceMonitor
    public init(monitor: SerialDeviceMonitor) {
        serialDeviceMonitor = monitor
    }
    public func start() {
        serialDeviceMonitor.filterDevices = { _ in
            []
        }
        DispatchQueue.global(qos: .background).async {
            self.serialDeviceMonitor.start()
        }
    }
}

extension ForcePlateMonitor: Starting {
}
