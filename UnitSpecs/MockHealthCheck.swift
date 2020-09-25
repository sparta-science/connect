import Testable
import Combine

final class MockHealthCheck: HealthCheck {
    var interval: TimeInterval?
    func checkHealth(every time: TimeInterval) -> AnyPublisher<Bool, Never> {
        interval = time
        return Just(true).eraseToAnyPublisher()
    }
}

extension MockHealthCheck: CreateAndInject {
    typealias ActAs = HealthCheck
}
