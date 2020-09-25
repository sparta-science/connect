import Testable

final class MockHealthCheck: HealthCheck {
    var check: ((Bool) -> Void)?
    func start(updating: @escaping (Bool) -> Void) {
        check = updating
    }

    var didCall: String?
    func cancel() {
        didCall = #function
    }
}

extension MockHealthCheck: CreateAndInject {
    typealias ActAs = HealthCheck
}
