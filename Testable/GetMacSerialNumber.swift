import Foundation

/**
 https://ourcodeworld.com/articles/read/1113/how-to-retrieve-the-serial-number-of-a-mac-with-swift
 https://developer.apple.com/library/archive/technotes/tn1103/
 Retrieves the serial number of your mac device.
 
 - Returns: The string with the serial.
 */
public func getMacSerialNumber() -> String {
    getPlatformExpertDevice(property: kIOPlatformSerialNumberKey)
}

public func getPlatformExpertDevice(property: String) -> String {
    var value: String? {
        let platformExpert = IOServiceGetMatchingService(
            kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")
        )

        defer {
            IOObjectRelease(platformExpert)
        }

        let property = IORegistryEntryCreateCFProperty(platformExpert,
                                                       property as CFString,
                                                       kCFAllocatorDefault,
                                                       0)

        guard let value = property?.takeUnretainedValue() as? String else {
            return nil
        }

        return value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    return value ?? "Unknown"
}
