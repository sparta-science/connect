import Foundation
import Testable

final class MockStateContainer: StateContainer {
    var didTransition: [String] = []
    var didProgress: Progress?

    func update(progress: Progress) {
        didProgress = progress
        didTransition.append(#function)
    }

    func complete() {
        didTransition.append(#function)
    }

    func reset() {
        didTransition.append(#function)
    }

    func startReceiving() {
        didTransition.append(#function)
    }
}

extension MockStateContainer: CreateAndInject {
    typealias ActAs = StateContainer
}
