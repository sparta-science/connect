import Testable
import USBDeviceSwift

public enum Identifier: Int {
    case stMicroelectronics = 0x0483
    case virtualComPort = 0x5740
}

public class ForcePlateMonitor {
    let serialDeviceMonitor: SerialDeviceMonitor
    public init(monitor: SerialDeviceMonitor) {
        serialDeviceMonitor = monitor
    }
}

extension ForcePlateMonitor: ForcePlateDetection {
    public func start(updating: @escaping (String) -> Void) {
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
