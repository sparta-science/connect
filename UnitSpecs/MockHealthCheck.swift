import Testable

final class MockHealthCheck: HealthCheck {
    var check: ((Bool) -> Void)?
    func update(complete: @escaping (Bool) -> Void) {
        check = complete
    }
}

extension MockHealthCheck: CreateAndInject {
    typealias ActAs = HealthCheck
}
