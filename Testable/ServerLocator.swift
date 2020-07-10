@objc
public protocol ServerLocatorProtocol {
    var availableServers: [String] { get }
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
        ApiServer.allCases.map { $0.rawValue }
            + DebugFileServer.allCases.map { $0.rawValue }
    }

    private func baseUrlString(_ server: String) -> String {
        if let apiServer = ApiServer(rawValue: server) {
            return apiServer.serverUrlString()
        } else {
            let file = DebugFileServer(rawValue: server)!.fileName()
            return json(file, bundle)
        }
    }
    private func json(_ resource: String, _ bundle: Bundle) -> String {
        bundle.url(forResource: resource, withExtension: "json")!.absoluteString
    }
}
