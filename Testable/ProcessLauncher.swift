import Foundation

open class ProcessLauncher {
    public init() {}

    open func runShellScript(script: URL, in folder: URL) throws {
        try run(command: "/bin/bash",
                args: ["-o", "errexit", script.path],
                in: folder)
    }

    open func run(command: String, args: [String], in folder: URL, ignoreErrors: [Int32] = []) throws {
        let errorPipe = Pipe()
        let process = Init(Process()) {
            $0.executableURL = URL(fileURLWithPath: command)
            $0.arguments = args
            $0.currentDirectoryURL = folder
            $0.standardError = errorPipe
        }

        try process.run()
        process.waitUntilExit()
        let successful = [kOSReturnSuccess] + ignoreErrors
        if !successful.contains(process.terminationStatus) {
            var message: String?
            if let data = try errorPipe.fileHandleForReading.readToEnd() {
                message = String(data: data, encoding: .utf8)
            }
            throw PresentableError.processExit(status: process.terminationStatus, message: message)
        }
    }
}
