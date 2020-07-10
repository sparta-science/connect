import Foundation

public enum BackEnd: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case staging
    case production

    var servers: [BackEnd: String] {
        [
            .localhost: "http://localhost:4000",
            .staging: "https://staging.spartascience.com",
            .production: "https://home.spartascience.com"
        ]
    }
    public func serverUrlString() -> String {
        servers[self].map { $0 + "/api/app-setup" }!
    }
}
