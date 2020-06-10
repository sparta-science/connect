import XCTest

class FileHelper {
    let fileManager = FileManager.default
    
    func remove(url: URL, file: StaticString = #file, line: UInt = #line) {
        try? fileManager.removeItem(at: url)
        XCTAssertFalse(fileManager.fileExists(atPath: url.path),
                       "should be removed", file: file, line: line)
    }
    
    func copy(_ from: URL, to destination: URL) {
        try! fileManager.copyItem(at: from, to: destination)
        XCTAssertTrue(fileManager.fileExists(atPath: destination.path))
    }
    
    func clearSubfolders(_ url: URL) {
        let subfolders = fileManager.enumerator(at: url,
                                                includingPropertiesForKeys: nil)!
        for case let fileURL as URL in subfolders {
            try? fileManager.removeItem(at: fileURL)
        }
    }
    
    func fileUrl(path: String, in directory: FileManager.SearchPathDirectory) -> URL {
        fileManager.urls(for: directory,
                         in: .userDomainMask).first!
            .appendingPathComponent(path)
    }
    
    func find(file: String, at url: URL) -> NSPredicate {
        NSPredicate { _, _  in
            let list = self.fileManager.enumerator(at: url,
                                                   includingPropertiesForKeys: nil)!
            return list.contains { ($0 as? URL)?.lastPathComponent == file }
        }
    }
}
