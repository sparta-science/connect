import Foundation

/**
 https://ourcodeworld.com/articles/read/1113/how-to-retrieve-the-serial-number-of-a-mac-with-swift
 https://developer.apple.com/library/archive/technotes/tn1103/
 Retrieves the serial number of your mac device.
 
 - Returns: The string with the serial.
 */
public func getMacSerialNumber() -> String {
    var serialNumber: String? {
        let platformExpert = IOServiceGetMatchingService(
            kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")
        )

        guard platformExpert > 0 else {
            return nil
        }

        defer {
            IOObjectRelease(platformExpert)
        }

        let serialNumberKey = kIOPlatformSerialNumberKey as CFString
        let property = IORegistryEntryCreateCFProperty(platformExpert,
                                                       serialNumberKey,
                                                       kCFAllocatorDefault,
                                                       0)

        guard let serialNumber = property?.takeUnretainedValue() as? String else {
            return nil
        }

        return serialNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    return serialNumber ?? "Unknown"
}
