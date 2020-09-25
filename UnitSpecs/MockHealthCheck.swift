import Combine
import Testable

final class MockHealthCheck: HealthCheck {
    var interval: TimeInterval?
    var publisher: AnyPublisher<Bool, Never>?
    func checkHealth(every time: TimeInterval) -> AnyPublisher<Bool, Never> {
        interval = time
        return publisher!
    }
}

extension MockHealthCheck: CreateAndInject {
    typealias ActAs = HealthCheck
}
