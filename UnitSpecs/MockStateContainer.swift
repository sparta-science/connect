import Foundation
import Testable

final class MockStateContainer: StateContainer {
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
