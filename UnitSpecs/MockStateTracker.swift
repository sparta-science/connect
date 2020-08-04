import Foundation
import Testable

final class MockStateTracker: StateTracker {
    var mockedState: State?
    override func loadState() -> State {
        mockedState!
    }
}

extension MockStateTracker: CreateAndInject {
    typealias ActAs = StateTracker
}
