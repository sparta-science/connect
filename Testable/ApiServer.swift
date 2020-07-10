import Foundation

public enum ApiServer: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case staging
    case production

    static let servers: [Self: String] = [
        .localhost: "http://localhost:4000",
        .staging: "https://staging.spartascience.com",
        .production: "https://home.spartascience.com"
    ]
    public func serverUrlString() -> String {
        Self.servers[self].map { $0 + "/api/app-setup" }!
    }
}
