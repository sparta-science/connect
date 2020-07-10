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
        BackEnd(rawValue: server)!.appSetupUrlString(bundle: bundle)
    }
}
