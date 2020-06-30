import Foundation

public enum State: Equatable {
    case login
    case busy(value: Progress)
    case complete
    public func progress() -> Progress? {
        if case let .busy(value: progress) = self {
            return progress
        }
        return nil
    }
}
