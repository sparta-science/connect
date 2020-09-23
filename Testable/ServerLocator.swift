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
        let host = ApiServer.displayNames.first {
            $0.value == server
        }
        return host!.key.serverUrlString()
    }
}

extension ServerLocator: ServerLocatorProtocol {
    public var availableServers: [String] {
        Array(ApiServer.displayNames.values).sorted()
    }
    public func loginRequest(_ login: Login) -> LoginRequest {
        Init(LoginRequest()) {
            $0.username = login.username!
            $0.password = login.password!
            $0.baseUrlString = baseUrlString(login.environment)
        }
    }
}
