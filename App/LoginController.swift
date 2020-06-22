import Cocoa
import Testable

public protocol NetworkServiceProtocol {
    func login(username: String) -> String
}

public protocol AlertProtocol {
    func show(alert: NSAlert)
}

public class NetworkService: NetworkServiceProtocol {
    public init() {}
    public func login(username: String) -> String {
        "success"
    }
}

@objcMembers
class Login: NSObject {
    var environment: String = "production"
    var username: String?
    var password: String?
}

public class LoginController: NSViewController {
    @objc var hideEnvironments: Bool = isReleaseBuild()
    @objc var login = Login()

    public var networkService: NetworkServiceProtocol = NetworkService()
    public var alertService: AlertProtocol!
    @IBAction public func connectAction(_ sender: NSButton) {
        if networkService.login(username: "sparta@example.com") == "success" {
            sender.window?.close()
        } else {
            alertService.show(alert: NSAlert())
        }
    }
}
