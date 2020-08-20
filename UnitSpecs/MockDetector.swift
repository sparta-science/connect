import Testable

final class MockDetector: ForcePlateDetection {
    var detection: ((String) -> Void)?
    func start(update: @escaping (String) -> Void) {
        detection = update
    }
}

extension MockDetector: CreateAndInject {
    typealias ActAs = ForcePlateDetection
}
