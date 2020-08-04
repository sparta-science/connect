import Foundation

public protocol StateContainer {
    var state: State { get set }
    func startReceiving()
    func reset()
    func complete()
    func update(progress: Progress)
}

open class StateCapsule {
    @Published public var state: State

    @Inject var defaults: UserDefaults
    public init() {
        state = .login
        state = loadState()
    }
    private func loadState() -> State {
        defaults.bool(forKey: "complete") ? .complete : .login
    }
}

extension StateCapsule: StateContainer {
    public func update(progress: Progress) {
        state = .busy(value: progress)
    }

    public func complete() {
        state = .complete
    }

    public func reset() {
        state = .login
    }

    public func startReceiving() {
        state = .startReceiving()
    }
}
