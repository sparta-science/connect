@objc
public protocol ServerLocatorProtocol {
    var availableServers: [String] { get }
    func loginRequest(_ login: Login) -> LoginRequest
}

public class ServerLocator: NSObject {
    @Inject var bundle: Bundle

    var jsonResouces: [BackEnd: String] {[
        .simulateFailure: "successful-response-invalid-tar",
        .simulateSuccess: "successful-response-valid-archive"
    ]}

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

    private func baseUrlString(_ server: String) -> String {
        let backEnd = BackEnd(rawValue: server)!
        if let serverUrl = backEnd.serverUrlString() {
            return serverUrl
        } else {
            return json(jsonResouces[backEnd]!, bundle)
        }
    }
    private func json(_ resource: String, _ bundle: Bundle) -> String {
        bundle.path(forResource: resource, ofType: "json")!
    }
}
