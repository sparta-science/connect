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
        state = .login
    }

    func startReceiving() {
        didTransition.append(#function)
        state = .startReceiving()
    }

    var mockedState: State?
    var state: State {
        get {
            mockedState!
        }
        set {
            mockedState = newValue
        }
    }
}

extension MockStateContainer: CreateAndInject {
    typealias ActAs = StateContainer
}
