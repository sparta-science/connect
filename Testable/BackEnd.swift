import Foundation

public enum BackEnd: String {
    case localhost
    case staging
    case production
    public func baseUrl() -> URL {
        let environment: [BackEnd: String] = [
            .localhost: "http://localhost:4000",
            .staging: "https://staging.spartascience.com",
            .production: "https://home.spartascience.com"
        ]
        return URL(string: environment[self]!)!
    }
}
