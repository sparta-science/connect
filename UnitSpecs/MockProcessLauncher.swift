import Foundation
import Testable

final class MockProcessLauncher: ProcessLauncher {
    var didRun: [String] = []
    override func run(command: String, args: [String], in folder: URL, ignoreErrors: [Int32]) throws {
        didRun.append(command)
        didRun.append(contentsOf: args)
        didRun.append(folder.absoluteString)
        didRun.append(contentsOf: ignoreErrors.map{ $0.description })
    }
}

extension MockProcessLauncher: CreateAndInject {
    typealias ActAs = ProcessLauncher
}

class MockErrorProcessLauncher: ProcessLauncher {
    var error: Error?
    override func run(command: String, args: [String], in folder: URL, ignoreErrors: [Int32]) throws {
        throw error!
    }
}
