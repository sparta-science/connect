import Foundation
import USBDeviceSwift

protocol Starting {
    func start()
}

public enum Identifier: Int {
    case stMicroelectronics = 0x0483
    case virtualComPort = 0x5740
}

public class ForcePlateMonitor {
    let serialDeviceMonitor: SerialDeviceMonitor
    public init(monitor: SerialDeviceMonitor) {
        serialDeviceMonitor = monitor
    }
    public func start() {
        serialDeviceMonitor.filterDevices = {
            $0.filter {
                $0.vendorId == Identifier.stMicroelectronics.rawValue
                    && $0.productId == Identifier.virtualComPort.rawValue
            }
        }
        DispatchQueue.global(qos: .background).async {
            self.serialDeviceMonitor.start()
        }
    }
}

extension ForcePlateMonitor: Starting {
}
