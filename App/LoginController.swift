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
public class Login: NSObject {
    var environment: String = "production"
    var username: String?
    var password: String?
}

public class LoginController: NSViewController {
    @objc var hideEnvironments: Bool = isReleaseBuild()

    public var networkService: NetworkServiceProtocol = NetworkService()
    public var alertService: AlertProtocol!
    @IBAction public func connectAction(_ sender: NSButton) {
        Installer.shared.beginInstallation(login: representedObject as! Login)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        let login = Login()
        #if DEBUG
        let env = ProcessInfo.processInfo.environment
        if let debugBackend = env["debug-backend"], !debugBackend.isEmpty {
            login.environment = debugBackend
        } else {
            login.environment = "staging"
        }
        login.username = env["debug-email"]
        login.password = env["debug-password"]
        #endif
        representedObject = login
    }
}
