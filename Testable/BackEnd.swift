import Foundation

public enum BackEnd: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case simulateFailure = "simulate install failure"
    case simulateSuccess = "simulate install success"
    case staging
    case production

    private func json(_ resource: String, _ bundle: Bundle) -> String {
        bundle.path(forResource: resource, ofType: "json")!
    }
    var jsonResouces: [BackEnd: String] {[
        .simulateFailure: "successful-response-invalid-tar",
        .simulateSuccess: "successful-response-valid-archive"
    ]}
    var servers: [BackEnd: String] {[
        .localhost: "http://localhost:4000",
        .staging: "https://staging.spartascience.com",
        .production: "https://home.spartascience.com"
    ].mapValues { $0 + "/api/app-setup" }
    }

    public func appSetupUrlString(bundle: Bundle) -> String {
        let simulated = jsonResouces.mapValues { json($0, bundle) }
        let combined = simulated.merging(servers) { $1 }
        return combined[self]!
    }
}
