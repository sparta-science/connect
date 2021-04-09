import Foundation

public enum ApiServer: CaseIterable {
    case localhost
    case offline
    case staging
    case production

    static let displayNames: [Self: String] = [
        .offline: "Sparta Offline System",
        .production: "home.spartascience.com"
    ]

    static let servers: [Self: String] = [
        .localhost: "http://localhost:4000",
        .offline: "http://spartascan.local",
        .staging: "https://staging.spartascience.com",
        .production: "https://home.spartascience.com"
    ]

    public func serverUrlString() -> String {
        if self == .production, let serverUrlString = AppSetupUrl().string {
            return serverUrlString
        }
        return Self.servers[self].map { $0 + "/api/app-setup" }!
    }
}

private class AppSetupUrl {
    @Inject var defaults: UserDefaults
    var string: String? {
        defaults.string(forKey: "custom app url")
    }
}
