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

public class LoginController: NSViewController {
    @objc var hideEnvironments: Bool = isReleaseBuild()

    public var networkService: NetworkServiceProtocol = NetworkService()
    public var alertService: AlertProtocol!
    @IBAction public func connectAction(_ sender: NSButton) {
        if networkService.login(username: "sparta@example.com") == "success" {
            sender.window?.close()
        } else {
            alertService.show(alert: NSAlert())
        }
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        representedObject = Login()
    }
}
