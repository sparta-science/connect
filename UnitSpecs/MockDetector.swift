import Testable

final class MockDetector: ForcePlateDetection {
    var detection: ((String?) -> Void)?
    func onChange(block: @escaping (String?) -> Void) {
        detection = block
    }
}

extension MockDetector: CreateAndInject {
    typealias ActAs = ForcePlateDetection
}
