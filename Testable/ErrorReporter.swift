import AppKit

public protocol ErrorReporting {
    func report(error: Error)
}

public class ErrorReporter: ErrorReporting {
    public func report(error: Error) {
        NSAlert(error: error).runModal()
    }
    public init() {}
}
