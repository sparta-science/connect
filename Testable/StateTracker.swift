import Foundation

open class StateTracker {
    @Inject var defaults: UserDefaults
    public init() {}
    open func loadState() -> State {
        defaults.bool(forKey: "complete") ? .complete : .login
    }
}
