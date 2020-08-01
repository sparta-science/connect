import Foundation

public enum PresentableError: LocalizedError {
    case processExit(status: Int32, message: String?)
    case server(message: String)
    public var errorDescription: String? {
        switch self {
        case .server:
            return "Server Error"
        case let .processExit(status, _):
            return "Failed with exit code: \(status)"
        }
    }
    public var recoverySuggestion: String? {
        switch self {
        case let .server(message):
            return message
        case let .processExit(_, message):
            return message
        }
    }
}
