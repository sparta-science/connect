import Combine
import Foundation

public protocol StateContainer {
    func startReceiving()
    func reset()
    func complete()
    func update(progress: Progress)
}

open class StateCapsule {
    @Published var state: State = .login
    @Inject var defaults: UserDefaults

    public init() {
        state = loadState()
    }
    public func publisher() -> AnyPublisher<State, Never> {
        $state.eraseToAnyPublisher()
    }
    private func loadState() -> State {
        defaults.bool(forKey: "complete") ? .complete : .login
    }
    private func save(complete: Bool) {
        defaults.set(complete, forKey: "complete")
    }
}

extension StateCapsule: StateContainer {
    public func update(progress: Progress) {
        if case .busy = state {
            state = .busy(value: progress)
        }
    }

    public func complete() {
        state = .complete
        save(complete: true)
    }

    public func reset() {
        state = .login
        save(complete: false)
    }

    public func startReceiving() {
        state = .busy(value: Init(.init()) {
            $0.kind = .file
            $0.fileOperationKind = .receiving
            $0.isCancellable = true
        })
    }
}
