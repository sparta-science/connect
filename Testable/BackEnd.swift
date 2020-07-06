import Foundation

public enum BackEnd: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case staging
    case production
    public func choices() -> [String] {
        AllCases().map { $0.rawValue }
    }
    public func baseUrl() -> URL {
        let environment: [BackEnd: String] = [
            .localhost: "http://localhost:4000",
            .staging: "https://staging.spartascience.com",
            .production: "https://home.spartascience.com"
        ]
        return URL(string: environment[self]!)!
    }
}
