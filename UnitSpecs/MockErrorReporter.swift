import Testable

final class MockErrorReporter: ErrorReporting {
    var didReport: Error?
    func report(error: Error) {
        didReport = error
    }
}

extension MockErrorReporter: CreateAndInject {
    typealias ActAs = ErrorReporting
}
