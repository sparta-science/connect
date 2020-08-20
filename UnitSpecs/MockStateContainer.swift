import Foundation
import Testable

final class MockStateContainer: StateContainer {
    func reset(after: () -> Void) {
        after()
        didTransition.append(#function)
    }

    var didTransition: [String] = []
    var didProgress: Progress?

    func update(progress: Progress) {
        didProgress = progress
        didTransition.append(#function)
    }

    func complete() {
        didTransition.append(#function)
    }

    func startReceiving() {
        didTransition.append(#function)
    }
}

extension MockStateContainer: CreateAndInject {
    typealias ActAs = StateContainer
}
