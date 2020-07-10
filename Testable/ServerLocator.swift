@objc
public protocol ServerLocatorProtocol {
    var availableServers: [String] { get }
    func loginRequest(_ login: Login) -> LoginRequest
}

public class ServerLocator: NSObject {
    override public init() {
        super.init()
    }
    func baseUrlString(_ server: String) -> String {
        ApiServer(rawValue: server)!.serverUrlString()
    }
}

extension ServerLocator: ServerLocatorProtocol {
    public var availableServers: [String] {
        ApiServer.allCases.map { $0.rawValue }
    }
    public func loginRequest(_ login: Login) -> LoginRequest {
        Init(LoginRequest()) {
            $0.username = login.username!
            $0.password = login.password!
            $0.baseUrlString = baseUrlString(login.environment)
        }
    }
}
