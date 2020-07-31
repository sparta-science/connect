import Foundation
import Testable

final class MockProcessLauncher: ProcessLauncher {
    var didRun: [String] = []
    override func run(command: String, args: [String], in folder: URL) throws {
        didRun.append(command)
        didRun.append(contentsOf: args)
        didRun.append(folder.absoluteString)
    }
}

extension MockProcessLauncher: CreateAndInject {
    typealias ActAs = ProcessLauncher
}

class MockErrorProcessLauncher: ProcessLauncher {
    var error: Error?
    override func run(command: String, args: [String], in folder: URL) throws {
        throw error!
    }
}
