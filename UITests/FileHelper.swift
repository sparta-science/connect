import Foundation

class FileHelper {
    let fileManager = FileManager.default
    
    func remove(url: URL, file: StaticString = #file, line: UInt = #line) {
        try? fileManager.removeItem(at: url)
        verify(
            !fileManager.fileExists(atPath: url.path),
            "should be removed: \(url.path)",
            file: file, line: line
        )
    }
    
    func copy(_ from: URL, to destination: URL) {
        try! fileManager.linkItem(at: from, to: destination)
        flushAllOpenStreams()
        syncFileSystem(for: destination)
    }
    
    func syncFileSystem(for fileUrl: URL) {
        let flushAndWait = SYNC_VOLUME_FULLSYNC & SYNC_VOLUME_WAIT
        let path = fileUrl.path.cString(using: .macOSRoman)!
        verifySuccess(sync_volume_np(path, flushAndWait))
    }
    
    func flushAllOpenStreams() {
        verifySuccess(fflush(nil))
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
