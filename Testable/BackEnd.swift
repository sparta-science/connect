import Foundation

public enum BackEnd: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case fakeServer
    case staging
    case production
    public func choices() -> [String] {
        AllCases().map { $0.rawValue }
    }
    public func baseUrl() -> URL {
        let fileUrlString = Bundle.main.url(forResource: "successful-response", withExtension: "json")!.absoluteString
        let environment: [BackEnd: String] = [
            .localhost: "http://localhost:4000/api/app-setup",
            .fakeServer: fileUrlString,
            .staging: "https://staging.spartascience.com/api/app-setup",
            .production: "https://home.spartascience.com/api/app-setup"
        ]
        return URL(string: environment[self]!)!
    }
}
