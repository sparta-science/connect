public enum KnownDevice: CaseIterable {
    case stMicroelectronicsVirtualComPort
    case ftdiUsbUart
    public func deviceIdentifier() -> ProductOfVendor {
        switch self {
        case .stMicroelectronicsVirtualComPort:
            return ProductOfVendor(vendor: 0x0483, product: 0x5740)
        case .ftdiUsbUart:
            return ProductOfVendor(vendor: 0x0403, product: 0x6001)
        }
    }
    public static var allDevices: [ProductOfVendor] {
        allCases.map { $0.deviceIdentifier() }
    }
}
