import Foundation

public enum BackEnd: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case fakeServer = "simulate install failure"
    case staging
    case production
    public func appSetupUrl(bundle: Bundle) -> URL {
        let fileUrlString = bundle.url(forResource: "successful-response-invalid-tar", withExtension: "json")!.absoluteString
        let environment: [BackEnd: String] = [
            .localhost: "http://localhost:4000/api/app-setup",
            .fakeServer: fileUrlString,
            .staging: "https://staging.spartascience.com/api/app-setup",
            .production: "https://home.spartascience.com/api/app-setup"
        ]
        return URL(string: environment[self]!)!
    }
}

@objc
public protocol ServerLocatorProtocol {
    var availableServers: [String] { get }
    func baseUrlString(_ server: String) -> String
    func loginRequest(_ login: Login) -> LoginRequest
}

public class ServerLocator: NSObject {
    @Inject var bundle: Bundle

    override public init() {
        super.init()
    }
}

extension ServerLocator: ServerLocatorProtocol {
    public func loginRequest(_ login: Login) -> LoginRequest {
        Init(LoginRequest()) {
            $0.username = login.username!
            $0.password = login.password!
            $0.baseUrlString = baseUrlString(login.environment)
        }
    }

    public var availableServers: [String] {
        BackEnd.allCases.map { $0.rawValue }
    }

    public func baseUrlString(_ server: String) -> String {
        BackEnd(rawValue: server)!.appSetupUrl(bundle: bundle).absoluteString
    }
}
