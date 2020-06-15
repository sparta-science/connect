import XCTest

class FileHelper {
    let fileManager = FileManager.default
    
    func remove(url: URL, file: StaticString = #file, line: UInt = #line) {
        try? fileManager.removeItem(at: url)
        XCTAssertFalse(fileManager.fileExists(atPath: url.path),
                       "should be removed", file: file, line: line)
    }
    
    func copy(_ from: URL, to destination: URL) {
        let duplicated = XCTestExpectation(description: "duplicated")
        NSWorkspace.shared.duplicate([from]) { (map, error) in
            XCTAssertNil(error)
            _ = try! self.fileManager.replaceItemAt(destination, withItemAt: map[from]!, backupItemName: nil, options: .usingNewMetadataOnly)
            duplicated.fulfill()
        }
        XCTWaiter.wait(until: duplicated, timeout: .install, "should copy")
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
    
    func applications(home: URL) -> URL {
        home.appendingPathComponent("Applications")
    }
    
    func hasFilesIn(url: URL) -> Bool {
        if let list = try? fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil,
            options: []) {
            return list.count > 1
        }
        return false
    }
    
    func preferredApplicationsUrl() -> URL {
        let home = fileManager.homeDirectoryForCurrentUser
        let userAppsUrl = applications(home: home)
        if hasFilesIn(url: userAppsUrl) {
            return userAppsUrl
        }
        return applications(home: URL(fileURLWithPath: "/"))
    }
}
