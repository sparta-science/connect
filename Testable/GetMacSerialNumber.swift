import Foundation

/**
 https://ourcodeworld.com/articles/read/1113/how-to-retrieve-the-serial-number-of-a-mac-with-swift
 Retrieves the serial number of your mac device.
 
 - Returns: The string with the serial.
 */
public func getMacSerialNumber() -> String {
    var serialNumber: String? {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )

        guard platformExpert > 0 else {
            return nil
        }

        guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert,
                                                                  kIOPlatformSerialNumberKey as CFString,
                                                                  kCFAllocatorDefault,
                                                                  0).takeUnretainedValue() as? String)?
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
                return nil
        }

        IOObjectRelease(platformExpert)

        return serialNumber
    }

    return serialNumber ?? "Unknown"
}
