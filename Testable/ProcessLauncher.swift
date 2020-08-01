import Foundation

open class ProcessLauncher {
    public init() {}

    open func runShellScript(script: URL, in folder: URL) throws {
        try run(command: "/bin/bash",
                args: ["-o", "errexit", script.path],
                in: folder)
    }

    open func run(command: String, args: [String], in folder: URL) throws {
        let errorPipe = Pipe()
        let process = Init(Process()) {
            $0.executableURL = URL(fileURLWithPath: command)
            $0.arguments = args
            $0.currentDirectoryURL = folder
            $0.standardError = errorPipe
        }

        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != kOSReturnSuccess {
            var message: String?
            if let data = try errorPipe.fileHandleForReading.readToEnd() {
                message = String(data: data, encoding: .utf8)
            }
            throw PresentableError.processExit(status: process.terminationStatus, message: message)
        }
    }
}
