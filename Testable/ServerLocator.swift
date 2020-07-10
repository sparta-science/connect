@objc
public protocol ServerLocatorProtocol {
    var availableServers: [String] { get }
    func loginRequest(_ login: Login) -> LoginRequest
}

public class ServerLocator: NSObject {
    @Inject var bundle: Bundle

    var mockServers: [String: String] {[
        "simulate install failure": "successful-response-invalid-tar",
        "simulate install success": "successful-response-valid-archive"
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
        ApiServer.allCases.map { $0.rawValue } + Array(mockServers.keys)
    }

    private func baseUrlString(_ server: String) -> String {
        if let mock = mockServers[server] {
            return json(mock, bundle)
        } else {
            return ApiServer(rawValue: server)!.serverUrlString()
        }
    }
    private func json(_ resource: String, _ bundle: Bundle) -> String {
        bundle.path(forResource: resource, ofType: "json")!
    }
}
