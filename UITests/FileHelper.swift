import XCTest

class FileHelper {
    let fileManager = FileManager.default

    func remove(url: URL, file: StaticString = #file, line: UInt = #line) {
        try? fileManager.removeItem(at: url)
        XCTAssertFalse(fileManager.fileExists(atPath: url.path),
                       "should be removed", file: file, line: line)
    }
    
    func copy(path: String, to destination: URL) {
        try! fileManager.copyItem(at: URL(fileURLWithPath: path), to: destination)
        XCTAssertTrue(fileManager.fileExists(atPath: destination.path))
    }
}
