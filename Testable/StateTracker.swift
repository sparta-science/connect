import Foundation

public class StateTracker {
    @Inject var defaults: UserDefaults
    public init() {}
    public func loadState() -> State {
        defaults.bool(forKey: "complete") ? .complete : .login
    }
}
