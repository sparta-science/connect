import Foundation

public enum State: Hashable {
    case login
    case busy(value: Progress)
    case complete
    public func progress() -> Progress? {
        if case let .busy(value: progress) = self {
            return progress
        }
        return nil
    }
    public static func startReceiving() -> Self {
        .busy(value: Init(Progress()) {
            $0.kind = .file
            $0.fileOperationKind = .receiving
            $0.isCancellable = true
        })
    }
}
