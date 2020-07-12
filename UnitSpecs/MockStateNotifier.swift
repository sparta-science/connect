import Testable

final class MockStateNotifier: StateNotifier {
    func send(state: State) {
        receiver!(state)
    }
    var receiver: ((State) -> Void)?
    override func start(receiver: @escaping (State) -> Void) {
        self.receiver = receiver
    }
}

extension MockStateNotifier: CreateAndInject {
    typealias ActAs = StateNotifier
}
