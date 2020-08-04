import Foundation

open class StateTracker {
    @Published public var state: State = .login

    @Inject var defaults: UserDefaults
    public init() {}
    open func loadState() -> State {
        defaults.bool(forKey: "complete") ? .complete : .login
    }
}
