import Foundation

public class StateTracker {
    public init() {}
    public func loadState() -> State {
        UserDefaults.standard.bool(forKey: "complete") ? .complete : .login
    }
}
