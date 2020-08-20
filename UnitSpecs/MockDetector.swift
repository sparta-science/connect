import Testable

final class MockDetector: ForcePlateDetection {
    var detection: ((String) -> Void)?
    func start(updating: @escaping (String) -> Void) {
        detection = updating
    }
}

extension MockDetector: CreateAndInject {
    typealias ActAs = ForcePlateDetection
}
