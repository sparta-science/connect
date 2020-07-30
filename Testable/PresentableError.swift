import Foundation

public enum PresentableError: LocalizedError {
    case installation(status: Int32, message: String?)
    case server(message: String)
    public var errorDescription: String? {
        switch self {
        case .server:
            return "Server Error"
        case let .installation(status, _):
            return "Failed to install with exit code: \(status)"
        }
    }
    public var recoverySuggestion: String? {
        switch self {
        case let .server(message):
            return message
        case let .installation(_, message):
            return message
        }
    }
}
