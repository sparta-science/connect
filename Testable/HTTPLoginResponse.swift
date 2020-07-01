import Foundation

public struct Organization: Codable {
    public let id: Int
    public let logoUrl: String?
    public let name: String
    public let touchIconUrl: String?
}

public struct ResponseSuccess: Codable {
    public let message: HTTPLoginMessage
    public let vernalFallsConfig: [String: String]
    public let org: Organization
}

public struct ResponseFailure: Codable {
    public let error: String
}

public enum HTTPLoginResponse: Codable {
    public init(from decoder: Decoder) throws {
        if let decoded = try? Self.success(ResponseSuccess(from: decoder)) {
            self = decoded
        } else {
            self = try Self.failure(ResponseFailure(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .success(value: let success):
            try success.encode(to: encoder)
        case .failure(value: let failure):
            try failure.encode(to: encoder)
        }
    }

    case success(_:ResponseSuccess)
    case failure(_:ResponseFailure)
}

public struct HTTPLoginMessage: Codable {
    let downloadUrl: URL
    let vernalFallsVersion: String
}
