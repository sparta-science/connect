import Foundation
import Testable

final class MockStateContainer: StateContainer {
    func update(progress: Progress) {
        if case .busy = state {
            state = .busy(value: progress)
        }
    }

    func complete() {
        state = .complete
    }

    func reset() {
        state = .login
    }

    func startReceiving() {
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
