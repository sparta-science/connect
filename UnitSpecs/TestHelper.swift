import Foundation

extension FourCharCode {
    private static let bytesSize = MemoryLayout<Self>.size
    var codeString: String {
        get {
            withUnsafePointer(to: bigEndian) { pointer in
                pointer.withMemoryRebound(to: UInt8.self, capacity: Self.bytesSize) { bytes in
                    String(bytes: UnsafeBufferPointer(start: bytes,
                                                      count: Self.bytesSize),
                           encoding: .macOSRoman)!
                }
            }
        }
    }
}

extension OSStatus {
    var codeString: String {
        FourCharCode(bitPattern: self).codeString
    }
}

private func fourChars(_ string: String) -> String? {
    string.count == MemoryLayout<FourCharCode>.size ? string : nil
}
private func fourBytes(_ string: String) -> Data? {
    fourChars(string)?.data(using: .macOSRoman, allowLossyConversion: false)
}
func stringCode(_ string: String) -> FourCharCode {
    fourBytes(string)?.withUnsafeBytes { $0.load(as: FourCharCode.self).byteSwapped } ?? 0
}

extension NSObject {
    func imposing<T: AnyObject>(_ block: (T) -> Void) {
        object_setClass(self, T.self)
        block(unsafeBitCast(self, to: T.self))
        object_setClass(self, Self.self)
    }
}

func uninitialized<T>() -> T {
    unsafeBitCast(nil as T?, to: T.self)
}

extension URL {
    func fileSize() -> Int? {
        (try? resourceValues(forKeys: [.fileSizeKey]))?.fileSize
    }
}

extension RunLoop {
    static func run(for timeInterval: TimeInterval) {
        current.run(until: Date(timeIntervalSinceNow: timeInterval))
    }
}

func temp(path: String) -> URL {
    URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
}
